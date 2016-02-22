FROM alpine:3.3

# Here we use several hacks collected from https://github.com/gliderlabs/docker-alpine/issues/11:
# 1. install GLibc (which is not the cleanest solution at all)
# 2. hotfix /etc/nsswitch.conf, which is apperently required by glibc and is not used in Alpine Linux
RUN apk add --no-cache --virtual=build-dependencies curl ca-certificates && \
    export ALPINE_GLIBC_BASE_URL="https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64" && \
    export ALPINE_GLIBC_PACKAGE="glibc-2.21-r2.apk" && \
    export ALPINE_GLIBC_BIN_PACKAGE="glibc-bin-2.21-r2.apk" && \
    curl -jL https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk \
        | cat > /tmp/glibc-2.21-r2.apk && \
    curl -jL https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk \
        | cat > /tmp/glibc-bin-2.21-r2.apk &&\   
    apk add --no-cache --allow-untrusted /tmp/glibc-2.21-r2.apk /tmp/glibc-bin-2.21-r2.apk && \
    /usr/glibc/usr/bin/ldconfig "/lib" "/usr/glibc/usr/lib" && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    rm -rf /tmp/* && \
    mkdir -p /usr/lib/jvm/default-jvm && \
    curl -jkLH "Cookie: oraclelicense=accept-securebackup-cookie;" http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-x64.tar.gz \
        | tar -xz \
           --exclude=jdk1.8.0_66/*src.zip \
           --exclude=jdk1.8.0_66/lib/missioncontrol \
           --exclude=jdk1.8.0_66/lib/visualvm \
           --exclude=jdk1.8.0_66/lib/*javafx* \
           --exclude=jdk1.8.0_66/jre/lib/plugin.jar \
           --exclude=jdk1.8.0_66/jre/lib/ext/jfxrt.jar \
           --exclude=jdk1.8.0_66/jre/bin/javaws \
           --exclude=jdk1.8.0_66/jre/lib/javaws.jar \
           --exclude=jdk1.8.0_66/jre/lib/desktop \
           --exclude=jdk1.8.0_66/jre/plugin \
           --exclude=jdk1.8.0_66/jre/lib/deploy* \
           --exclude=jdk1.8.0_66/jre/lib/*javafx* \
           --exclude=jdk1.8.0_66/jre/lib/*jfx* \
           --exclude=jdk1.8.0_66/jre/lib/amd64/libdecora_sse.so \
           --exclude=jdk1.8.0_66/jre/lib/amd64/libprism_*.so \
           --exclude=jdk1.8.0_66/jre/lib/amd64/libfxplugins.so \
           --exclude=jdk1.8.0_66/jre/lib/amd64/libglass.so \
           --exclude=jdk1.8.0_66/jre/lib/amd64/libgstreamer-lite.so \
           --exclude=jdk1.8.0_66/jre/lib/amd64/libjavafx*.so \
           --exclude=jdk1.8.0_66/jre/lib/amd64/libjfx*.so \
           --exclude=jdk1.8.0_66/jre/bin/jjs \
           --exclude=jdk1.8.0_66/jre/bin/keytool \
           --exclude=jdk1.8.0_66/jre/bin/orbd \
           --exclude=jdk1.8.0_66/jre/bin/pack200 \
           --exclude=jdk1.8.0_66/jre/bin/policytool \
           --exclude=jdk1.8.0_66/jre/bin/rmid \
           --exclude=jdk1.8.0_66/jre/bin/rmiregistry \
           --exclude=jdk1.8.0_66/jre/bin/servertool \
           --exclude=jdk1.8.0_66/jre/bin/tnameserv \
           --exclude=jdk1.8.0_66/jre/bin/unpack200 \
           --exclude=jdk1.8.0_66/jre/lib/ext/nashorn.jar \
           --exclude=jdk1.8.0_66/jre/lib/jfr.jar \
           --exclude=jdk1.8.0_66/jre/lib/jfr \
           --exclude=jdk1.8.0_66/jre/lib/oblique-fonts  \
         -f - -C /usr/lib/jvm/default-jvm && \
       apk del build-dependencies curl ca-certificates && \
       rm -rf /tmp/*