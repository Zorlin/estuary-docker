
FROM node:14
ARG ESTUARY_HOSTNAME
ARG ESTUARY_TOKEN
ARG TEMPLATE_HOSTNAME=https://api.estuary.tech
RUN apt-get update && apt-get install -y git
WORKDIR /usr/src/estuary-www
RUN git clone https://github.com/application-research/estuary-www . && \
    npm install && \
    npm run build
COPY start.sh /usr/src/estuary-www/start.sh
RUN chmod +x /usr/src/estuary-www/start.sh
CMD /usr/src/estuary-www/start.sh
