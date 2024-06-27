FROM node:20

# zorg dat sqlite later bij de yarn install een python executable kan vinden
RUN ln -s /usr/bin/python3 /usr/bin/python & \
    ln -s /usr/bin/pip3 /usr/bin/pip

WORKDIR /myapp
COPY package.json \
     .meshrc.yaml \
     locatieserver_openapi.yaml .

ENV RVO_KEY=NTIwMzI0NDFENEEwNzVGRTI5REJFN0U1MkZENzNERDkwNTIxQjJBMTkwOUUwNTY2ODFFOTk0RUY0NTY3REZDNDI2MkU5OTY2Q0QxRUEzODk5M0EwNUNERUU1OTY1NjFD
ENV BAG_KEY=l7361fb3d5ed6144c9b5efc47f3ce956e2
ENV AMS_KEY=eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.eyJzdWIiOjczODE5MzgzMTY0NDgyMjEyNjQsImV4cCI6MTc0NTUwNDUzOX0.IGl0rCK9OTTliH9j96C1DsAH5HQvcZ8e0PI0IXe_i3fVzgHKIAJe1VmjRYPzUHKF5xfm__ogiRY53oEbb5ALBA
ENV TIBBER_KEY=5K4MVS-OjfWhK_4yrjOlFe1F6kJXPVf7eQYggo8ebAE
ENV DEBUG=1
EXPOSE 80

RUN yarn install 
CMD yarn mesh dev
