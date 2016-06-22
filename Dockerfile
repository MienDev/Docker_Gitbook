FROM node:6.2.2
MAINTAINER Mien <mien@dreamxo.net>

# install dependencies
RUN apt-get update && \
    apt-get install -y --in-install-recommends unzip calibre xsltproc curl && \
    rm -rf /var/lib/apt/lists/*

## Install Calibre
RUN echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends calibre fonts-noto fonts-noto-cjk locales-all && \
    rm -rf /var/lib/apt/lists/*

# install gitbook toolchain
RUN npm install -g gitbook-cli ebook-convert && \
    gitbook fetch

# cache plugins 
# RUN npm install -g gitbook-plugin-search-jieba

# clean up (apt)
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* /root/.npm /tmp/npm*

ENV BOOKROOT /var/www/gitbook/
COPY . $BOOKROOT
WORKDIR $BOOKROOT
RUN gitbook install 
RUN rm -f *.* && \
    rm -rf searchindex

EXPOSE 4000

CMD ["gitbook","serve"]