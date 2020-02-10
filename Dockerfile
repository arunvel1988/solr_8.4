FROM ubuntu

LABEL maintainer="arun"
LABEL repository="https://github.com/arunvel1988/"




RUN apt update -y && apt install wget -y && apt install openjdk-11-jdk -y 
RUN set -ex; \
  apt-get update; \
  apt-get -y install acl dirmngr gpg lsof procps wget netcat; \
  rm -rf /var/lib/apt/lists/*

ENV SOLR_USER="solr" \
    SOLR_UID="8983" \
    SOLR_GROUP="solr" \
    SOLR_GID="8983" 



RUN set -ex; \
  groupadd -r --gid "$SOLR_GID" "$SOLR_GROUP"; \
  useradd -r --uid "$SOLR_UID" --gid "$SOLR_GID" "$SOLR_USER"


 RUN set -ex; \
 cd /opt; \
 
wget https://archive.apache.org/dist/lucene/solr/8.3.1/solr-8.3.1.tgz; \ 
tar xzf solr-8.3.1.tgz solr-8.3.1; \
    chown -R solr:solr "/opt/solr-8.3.1"; \
    chmod -R +777 /opt/solr-8.3.1; \
    mkdir -p /opt/solr-8.3.1/server/logs; \
    chown -R  solr:solr /opt/solr-8.3.1/server/logs;  \
    chmod -R 777 /opt/solr-8.3.1/server/logs;
COPY ssl /ssl
COPY solr.in.sh /etc/default/solr.in.sh
VOLUME /var/solr
EXPOSE 8983
WORKDIR /opt/solr-8.3.1
USER $SOLR_USER

CMD ["bin/solr", "start","-f"]



