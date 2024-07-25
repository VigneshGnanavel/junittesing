FROM jenkins/jenkins:lts
USER root
RUN apt-get update && \
    apt-get install -y \
        openjdk-11-jdk \
        maven \
        curl && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g snyk && \
    curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER jenkins
