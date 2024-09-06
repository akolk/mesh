FROM node:20.17-alpine3.20@sha256:1a526b97cace6b4006256570efa1a29cd1fe4b96a5301f8d48e87c5139438a45

RUN apk update && apk upgrade
RUN apk add curl
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python

# zorg dat sqlite later bij de yarn install een python executable kan vinden
RUN ln -s /usr/bin/python3 /usr/bin/python & \
    ln -s /usr/bin/pip3 /usr/bin/pip

RUN python -v
RUN which python
RUN which python3

WORKDIR /myapp
COPY package.json \
     .meshrc.yaml \
     locatieserver_openapi.yaml .

EXPOSE 80

RUN yarn install 
CMD ["yarn", "mesh", "dev"]
