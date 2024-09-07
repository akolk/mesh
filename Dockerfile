FROM node:20.17-alpine3.20@sha256:9fde95f2c4d8aa5abe327ef69565dd944321ed8541b1df86041b41d63d54c215

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
