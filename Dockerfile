FROM curlimages/curl:7.76.1

COPY LICENSE README.md /

COPY entrypoint.sh /entrypoint.sh

USER root
RUN apk add jq
USER curl_user

ENTRYPOINT ["/entrypoint.sh"]
