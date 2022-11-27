FROM alpine:3

RUN apk --update --no-cache add git git-lfs aws-cli jq bash

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
