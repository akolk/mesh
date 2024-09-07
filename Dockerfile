FROM node:20.17-alpine3.20@sha256:2d07db07a2df6830718ae2a47db6fedce6745f5bcd174c398f2acdda90a11c03

RUN apk update && apk upgrade && apk add --no-cache make gcc g++
RUN apk add curl
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN apk add curl-dev python3-dev

# zorg dat sqlite later bij de yarn install een python executable kan vinden
RUN ln -s /usr/bin/python3 /usr/bin/python & \
    ln -s /usr/bin/pip3 /usr/bin/pip

WORKDIR /myapp
COPY package.json \
     .meshrc.yaml \
     locatieserver_openapi.yaml \
     CBS85496.xml \
     CBS70072.xml .

EXPOSE 80

RUN yarn install 
CMD ["yarn", "mesh", "dev"]
