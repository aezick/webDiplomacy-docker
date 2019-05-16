FROM linode/lamp
LABEL maintainer="timothy.l.jones@gmail.com"

# Finish setting up server
RUN apt-get update
RUN apt-get install -y php5-mysql php5-gd libgd2-xpm-dev
RUN apt-get install -y libfreetype6
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN rm /var/www/example.com/public_html/index.html


ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.8/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=be43e64c45acd6ec4fce5831e03759c89676a0ea

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

# Add webDiplomacy harness
ADD scripts /scripts
ADD gameCron /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
RUN crontab /etc/cron.d/hello-cron

# install the database
ADD webDiplomacy/install /db_install
RUN /scripts/init-db.sh

CMD  ./scripts/docker-entrypoint.sh