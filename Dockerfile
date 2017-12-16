FROM jbonachera/alpine
RUN apk -U add ca-certificates curl && curl -Lo /bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
   chmod +x /bin/kubectl && \
   apk del curl && \
   rm -rf /var/cache/apk/*
COPY entrypoint.sh /sbin/entrypoint
ENTRYPOINT ["/sbin/entrypoint"]
