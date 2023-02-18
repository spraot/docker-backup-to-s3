FROM python:3.11-slim-bullseye

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update \
    & apt-get -y upgrade

WORKDIR /app

COPY requirements.txt ./
RUN pip install -r requirements.txt

ADD start.sh /start.sh
RUN chmod +x /start.sh

ADD put.sh /put.sh
RUN chmod +x /put.sh

ENTRYPOINT ["/start.sh"]
CMD [""]
