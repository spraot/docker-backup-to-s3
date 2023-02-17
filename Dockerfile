FROM amazon/aws-cli:latest

RUN apt-get update && \
    apt-get upgrade && \
    rm -rf /var/lib/apt/lists/*

ADD start.sh /start.sh
RUN chmod +x /start.sh

ADD sync.sh /put.sh
RUN chmod +x /put.sh

ENTRYPOINT ["/start.sh"]
CMD [""]
