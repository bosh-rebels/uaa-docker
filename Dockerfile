FROM cfidentity/uaa-consolidated

RUN cd /var/share && \
    git clone https://github.com/cloudfoundry/uaa.git
RUN cd /var/share/uaa && \
    ./gradlew clean assemble
RUN cd /var/share/uaa && \
    ./gradlew cargoConfigureLocal

COPY cargo /var/share/uaa/scripts/cargo

ENV DB="hsqldb"
ENV DB_NAME="uaa"
ENV DB_PASS="changeme"
ENV DB_USER="root"
ENV JAVA_HOME="/usr/lib/jvm/java-bellsoft-amd64"
ENV NUM_DBS="24"
ENV PATH="/usr/lib/jvm/java-bellsoft-amd64/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

ENTRYPOINT ["bash", "-c", "java -DCLOUDFOUNDRY_CONFIG_PATH=/var/share/uaa/scripts/cargo -Dlog4j.configurationFile=/var/share/uaa/scripts/cargo/log4j2.properties -Dstatsd.enabled=true -Xms128m -Xmx512m -Dsmtp.host=localhost -Dmetrics.perRequestMetrics=true -DSECRETS_DIR=/var/share/uaa/scripts/cargo -Dsmtp.port=2525 -Dspring.profiles.active=default -Dcatalina.home=/var/share/uaa/build/extract/tomcat-9.0.45/apache-tomcat-9.0.45 -Dcatalina.base=/tmp/uaa-8080 -Djava.io.tmpdir=/tmp/uaa-8080/temp -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djava.util.logging.config.file=/tmp/uaa-8080/conf/logging.properties -classpath /var/share/uaa/build/extract/tomcat-9.0.45/apache-tomcat-9.0.45/bin/tomcat-juli.jar:/var/share/uaa/build/extract/tomcat-9.0.45/apache-tomcat-9.0.45/bin/bootstrap.jar org.apache.catalina.startup.Bootstrap start"]

