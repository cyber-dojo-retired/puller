FROM cyberdojo/rack-base:bd4161e
LABEL maintainer=jon@jaggersoft.com

RUN apk add --no-cache tini
RUN gem install --no-document 'httpray'

COPY --chown=nobody:nogroup . /app

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}

ARG CYBER_DOJO_PULLER_PORT
ENV PORT=${CYBER_DOJO_PULLER_PORT}
EXPOSE ${PORT}

USER nobody
ENTRYPOINT ["/sbin/tini", "-g", "--"]
CMD [ "/app/up.sh" ]
