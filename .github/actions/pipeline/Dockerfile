FROM ubuntu:18.04

COPY entrypoint.sh /entrypoint.sh
COPY ../../Dockerfile /Dockerfile
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
