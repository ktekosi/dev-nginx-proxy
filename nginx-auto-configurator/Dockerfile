FROM alpine

RUN apk update
RUN apk add docker
RUN apk add jq
RUN apk add sed
RUN apk add bash
RUN apk add findutils

COPY ./src/env-watch.sh /app/env-watch.sh
COPY ./src/set-env.sh /app/set-env.sh
COPY ./src/set-site-hostname.sh /app/set-site-hostname.sh
COPY ./src/healthcheck.sh /app/healthcheck.sh

CMD /app/env-watch.sh