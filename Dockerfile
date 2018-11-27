FROM google/cloud-sdk
MAINTAINER j.ciolek@webnicer.com
WORKDIR /tmp
COPY webdriver-versions.js ./
ENV CHROME_PACKAGE="google-chrome-stable_59.0.3071.115-1_amd64.deb" NODE_PATH=/usr/local/lib/node_modules:/protractor/node_modules

RUN apt-get update && \
  apt-get install -y \
    supervisor \
    netcat-traditional \
    xvfb \
    openjdk-8-jre \
    chromium \
    ffmpeg \
    curl \
    gnupg \
    sudo \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get update && \
  apt-get install -y nodejs && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install Protractor and initialized Webdriver
RUN npm install -g protractor@^5.4 && \
  webdriver-manager update
COPY protractor.sh /
COPY environment /etc/sudoers.d/
# Fix for the issue with Selenium, as described here:
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null SCREEN_RES=1280x1024x24
WORKDIR /protractor
ENTRYPOINT ["/protractor.sh"]
