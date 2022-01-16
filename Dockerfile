FROM debian:10-slim

# app versions to use
ARG TERRARIA_VERSION=1421
ARG WRAPPER_VERSION=1.0.2

# run updates
RUN apt-get -y update \
    && apt-get -y install wget unzip jq file \
    && apt-get -y clean

# install game-docker-wrapper for graceful exiting
RUN wget -P /usr/local/bin "https://github.com/iagox86/game-docker-wrapper/releases/download/${WRAPPER_VERSION}/game-docker-wrapper" \
    && chmod 755 /usr/local/bin/game-docker-wrapper

# install terraria here
WORKDIR /terraria-server

# download and unpack the terraria server
RUN wget "https://terraria.org/api/download/pc-dedicated-server/terraria-server-${TERRARIA_VERSION}.zip" \
    && unzip terraria-server-${TERRARIA_VERSION}.zip \
    && mv ${TERRARIA_VERSION}/Linux/* . \
    && chmod u+x TerrariaServer* \
    && rm -rf ${TERRARIA_VERSION} \
    && rm terraria-server-${TERRARIA_VERSION}.zip

# copy files
COPY serverconfig.tmpl .
COPY startup.sh /

# Environment variables for server config
ENV TERRARIA_SERVER_PASSWORD="" \
    TERRARIA_SERVER_MAXPLAYERS=8 \
    TERRARIA_SERVER_MOTD="Please don't cut the purple trees!" \
    TERRARIA_SERVER_LANGUAGE="en/US" \
    TERRARIA_SERVER_SECURE=0 \
    TERRARIA_JOURNEY_TIME=2 \
    TERRARIA_JOURNEY_WEATHER=2 \
    TERRARIA_JOURNEY_GODMODE=2 \
    TERRARIA_JOURNEY_PLACEMENT=2 \
    TERRARIA_JOURNEY_DIFFICULTY=2 \
    TERRARIA_JOURNEY_BIOMESPREAD=2 \
    TERRARIA_JOURNEY_SPAWNRATE=2 \
    TERRARIA_WORLD_NAME="World" \
    TERRARIA_WORLD_SIZE=3 \
    TERRARIA_WORLD_DIFFICULTY=0 \
    TERRARIA_WORLD_SEED=""

# ports used
EXPOSE 7777

# volume for persistent data
Volume ["/data"]

# start server
ENTRYPOINT ["/startup.sh"]
