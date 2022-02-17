FROM ubuntu:20.04

ARG USERNAME=kwy8791
ARG PASSWORD="hogefugawerv"   # ここは変えましょう
ARG GRPNAME=kwy8791
ARG SYSGRPNAME=sudo
ARG UID=1000

ENV DEBIAN_FRONTEND noninteractive

RUN /usr/bin/apt-get update -q -qq
RUN /usr/bin/apt-get upgrade -q -qq
RUN /usr/bin/apt-get install sudo ssh \
                             vim make \
                             apt-utils \
                             openssl \
                             zlib1g-dev \
                             gcc \
                             libssl-dev -y
RUN /usr/bin/apt-get install software-properties-common -q -qq -y
RUN /usr/sbin/useradd -m --home-dir /home/${USERNAME}/ --groups ${SYSGRPNAME} --shell /bin/sh -u ${UID} ${USERNAME}

RUN /usr/bin/add-apt-repository ppa:git-core/ppa
RUN /usr/bin/apt-get update -q -qq
RUN /usr/bin/apt-get upgrade -q -qq
RUN /usr/bin/apt-get install git -q -qq -y
RUN /usr/bin/mkdir -p /home/${USERNAME}/data
RUN /usr/bin/chown -R ${USERNAME}:${GRPNAME} /home/${USERNAME}

RUN /usr/bin/echo "${USERNAME}:${PASSWORD}" |/usr/sbin/chpasswd

USER ${USERNAME}
WORKDIR /home/${USERNAME}/

# https://rasumus.hatenablog.com/entry/2021/03/28/184822


RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv

ENV PATH /home/${USERNAME}/.rbenv/shims:/home/${USERNAME}/.rbenv/bin::$PATH

RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
RUN . ~/.bashrc
RUN rbenv rehash
RUN rbenv install -l
RUN rbenv install 3.1.0
RUN rbenv rehash
RUN rbenv versions
RUN rbenv global 3.1.0
