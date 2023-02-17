FROM woahbase/alpine-awscli:armv7l

ADD start.sh /start.sh
RUN chmod +x /start.sh

ADD put.sh /put.sh
RUN chmod +x /put.sh

ENTRYPOINT ["/start.sh"]
CMD [""]
