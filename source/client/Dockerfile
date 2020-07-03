FROM cyberdojo/rack-base:bd4161e
LABEL maintainer=jon@jaggersoft.com

RUN apk add --no-cache tini

WORKDIR /app
COPY --chown=nobody:nogroup . .

ARG CYBER_DOJO_PULLER_CLIENT_PORT
ENV PORT=${CYBER_DOJO_PULLER_CLIENT_PORT}
EXPOSE ${PORT}

USER nobody
ENTRYPOINT ["/sbin/tini", "-g", "--"]
CMD [ "/app/up.sh" ]
