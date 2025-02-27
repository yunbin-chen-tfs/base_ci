FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Yocto mandatory packages
RUN apt-get update && apt-get install -y --no-install-recommends \
	asciidoc \
	bash \
	bc \
	bison \
	build-essential \
	ca-certificates \
	chrpath \
	cpio \
	debianutils \
	diffstat \
	file \
	flex \
	gawk \
	gcc-multilib \
	g++-multilib \
	git \
	git-core \
	iproute2 \
	iputils-ping \
	libncurses5-dev \
	libsdl1.2-dev \
	libssl-dev \
	locales \
	python \
	python3 \
	python3-pexpect \
	python3-pip \
	rsync \
	ruby \
	socat \
	ssh \
	sshpass \
	subversion \
	sudo \
	swig \
	texinfo \
	unzip \
	wget \
	xterm \
	xxd \
	xz-utils \
	zip \
	&& rm -rf /var/lib/apt/lists/*

# Asciidoctor PDF generator for generating the manual
RUN gem install public_suffix -v 4.0.7
RUN gem install asciidoctor-pdf

RUN sed -i "s/# en_US\.UTF-8 UTF-8/en_US\.UTF-8 UTF-8/" /etc/locale.gen \
	&& locale-gen \
	&& dpkg-reconfigure locales

RUN echo 'ALL ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
