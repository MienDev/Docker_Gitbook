FROM node:6.2.2
MAINTAINER Mien <mien@dreamxo.net>

# install dependencies
RUN apt-get update && \
    apt-get install -y unzip calibre xsltproc curl

# install gitbook toolchain
RUN npm install -g gitbook-cli ebook-convert && \
    gitbook fetch

# cache plugins 
RUN npm install -g gitbook-plugin-search-jieba

# clean up (apt)
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* /root/.npm /tmp/npm*

ENV BOOKROOT /var/www/gitbook/
COPY . $BOOKROOT
WORKDIR $BOOKROOT
RUN gitbook install 
EXPOSE 4000

CMD ["gitbook","serve"]