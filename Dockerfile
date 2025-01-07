#FROM node:20.17-alpine3.20@sha256:2d07db07a2df6830718ae2a47db6fedce6745f5bcd174c398f2acdda90a11c03
FROM node:alpine3.20@sha256:afe1d673fc9a75ab625646f8d087dd490d267311a3983df66815ee3e120b1813

RUN apk update && apk upgrade && apk add --no-cache make gcc g++ curl
RUN apk add --update --no-cache python3 py3-pip py3-requests py3-yaml && ln -sf python3 /usr/bin/python
RUN apk add curl-dev python3-dev

# zorg dat sqlite later bij de yarn install een python executable kan vinden
#RUN ln -s /usr/bin/python3 /usr/bin/python & \
#    ln -s /usr/bin/pip3 /usr/bin/pip

WORKDIR /myapp

EXPOSE 80
COPY package.json  .
RUN yarn install 

COPY .meshrc.yaml \
     locatieserver_openapi.yaml \
     cbsopenapi.json \
     config.py \
     requirements.txt \
     datasets.txt .

#RUN pip3 install -r requirements.txt
RUN python3 config.py
RUN cat .meshrc.yaml
CMD ["yarn", "mesh", "dev"]
