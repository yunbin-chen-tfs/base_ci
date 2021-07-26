FROM jenkins/jenkins

USER root

# To be set to docker group, by default 134
ARG dockergid=134
RUN groupadd --gid ${dockergid} docker

RUN apt-get update && \
    apt-get install -y \
        docker.io \
        python3 \
        python3-setuptools \
        git \
        make \
        pkg-config \
        bash-completion \
        sudo \
        u-boot-tools && \
    rm -rf /var/lib/apt/lists/*

ADD https://bootstrap.pypa.io/get-pip.py get-pip.py
RUN python3 ./get-pip.py && \
    pip install ansible==2.9 \
        netaddr \
        docker \
        six

RUN git clone https://github.com/savoirfairelinux/cqfd.git && \
    cd cqfd && \
    make install && \
    cd .. && \
    rm -rf cqfd

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo && \
    sed -i '1s/python/python3/g' /usr/local/bin/repo && \
    chmod a+rx /usr/local/bin/repo

RUN usermod -aG docker jenkins && \
    usermod -aG sudo jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

VOLUME ["/var/jenkins_home", "/var/run/docker.sock", "/tmp"]

EXPOSE 8080 50000


# Avoid '@' symbol on workspace paths
ENV JAVA_OPTS="-Dhudson.slaves.WorkspaceList=X -Djava.awt.headless=true"

USER jenkins
