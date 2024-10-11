FROM ubuntu:latest

RUN apt update && \
apt-get install -y curl build-essential gnupg2 ca-certificates lsb-release

WORKDIR /opt/mern_app

ADD https://github.com/maham0612/mern-app.git .

RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs

# Install MongoDB
RUN  curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor && \
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/8.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-8.0.list && \
apt-get update && \
apt-get install -y mongodb-org

RUN npm install

WORKDIR ./frontend

RUN npm install

RUN npm run build

WORKDIR ..

EXPOSE 5000 27017

# Create a startup script
RUN echo '#!/bin/bash\n\
mkdir -p /data/db\n\
mongod --fork --logpath /var/log/mongodb.log --dbpath /data/db\n\
npm start' > /opt/mern_app/start.sh && \
    chmod +x /opt/mern_app/start.sh

# Use the startup script as the entry point
CMD ["/opt/mern_app/start.sh"]
