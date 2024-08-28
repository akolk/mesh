FROM node:20.17-alpine3.20@sha256:1a526b97cace6b4006256570efa1a29cd1fe4b96a5301f8d48e87c5139438a45

# zorg dat sqlite later bij de yarn install een python executable kan vinden
RUN ln -s /usr/bin/python3 /usr/bin/python & \
    ln -s /usr/bin/pip3 /usr/bin/pip

WORKDIR /myapp
COPY package.json \
     .meshrc.yaml \
     locatieserver_openapi.yaml .

EXPOSE 80

RUN yarn install 
CMD ["yarn", "mesh", "dev"]
