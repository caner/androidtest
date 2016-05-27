FROM ubuntu:16.04

MAINTAINER Caner Gural <cgural@gmail.com>

ENV ANDROID_SDK_URL="https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz" \
    ANDROID_BUILD_TOOLS_VERSION=23.0.3 \
    ANDROID_APIS="android-22,android-23" \
    ABIS="sys-img-x86_64-android-22" \
    ANT_HOME="/usr/share/ant" \
    MAVEN_HOME="/usr/share/maven" \
    GRADLE_HOME="/usr/share/gradle" \
    ANDROID_HOME="/opt/android-sdk-linux"

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install -y software-properties-common build-essential openjdk-8-jdk && \
    dpkg --add-architecture i386 && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install -y expect git wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl gradle

RUN cd /opt
RUN wget -q -O androidsdk.tgz ${ANDROID_SDK_URL}
RUN tar -x -z androidsdk.tgz 
RUN echo y | android update sdk -a -u -t platform-tools,${ANDROID_APIS},build-tools-${ANDROID_BUILD_TOOLS_VERSION},${ABIS}
RUN chmod a+x -R $ANDROID_HOME
RUN chown -R root:root $ANDROID_HOME

RUN echo "no" | android create avd \
                --force \
                --device "Nexus 5" \
                --name testdevice \
                --target android-22 \
                --abi default/x86_64 \
                --skin WVGA800 \
                --sdcard 512M

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq autoremove -y
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq clean

RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace

