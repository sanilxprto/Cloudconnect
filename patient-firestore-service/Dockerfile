FROM node:12

ENV APPDIR /opt/patient-services

WORKDIR /opt/patient-services

COPY package*.json $APPDIR/

RUN npm install

COPY src/ $APPDIR/src

EXPOSE 9000

CMD ["npm", "start"]
