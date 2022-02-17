#!/bin/bash

# 変数設定
if [ -z ${USERNAME} ]; then
    read -p 'please type linux user name in docker > ' USERNAME
fi

if [ -z ${PASSWORD} ]; then
    stty -echo
    read -p 'please type linux user password in docker > ' PASSWORD ;echo ""
    stty echo
fi

if [ -z ${SYSGRPNAME} ]; then
    read -p 'please type linux group who can execute sudo in docker > ' SYSGRPNAME
fi

if [ -z ${USERID} ]; then
    read -p 'please type linux user id in docker > ' USERID
fi

if [ -z ${IMAGENAME} ]; then
    read -p 'please type image name of docker > ' IMAGENAME
fi

if [ -z ${IMAGETAG} ]; then
    read -p 'please type tag of docker > ' IMAGETAG
fi

if [ -z ${RUBYVER} ]; then
    read -p 'please type version of ruby which will be installed > ' RUBYVER
fi

# ディレクトリ作成とか
for TARGETDIR in conf data; do
    if [ ! -d ${PWD}/${TARGETDIR} ]; then
        mkdir -p ${PWD}/${TARGETDIR}
    fi
done

if [ -d ${HOME}/.ssh ]; then
    if [ ! -d ${PWD}/conf/.ssh ]; then
        cd conf
        ln -s ${HOME}/.ssh .ssh
        cd ..
    fi
fi

# Dockerfile 生成 part. 1
cat << EOF > ./Dockerfile
FROM ubuntu:20.04

ARG USERNAME=${USERNAME}
ARG PASSWORD=${PASSWORD}
ARG SYSGRPNAME=${SYSGRPNAME}
ARG USERID=${USERID}
ARG RUBYVER=${RUBYVER}

EOF

# Dockerfile 生成 part. 2
cat << 'EOF' >> ./Dockerfile
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
RUN /usr/sbin/useradd -m --home-dir /home/${USERNAME}/ --groups ${SYSGRPNAME} --shell /bin/sh -u ${USERID} ${USERNAME}

RUN /usr/bin/add-apt-repository ppa:git-core/ppa
RUN /usr/bin/apt-get update -q -qq
RUN /usr/bin/apt-get upgrade -q -qq
RUN /usr/bin/apt-get install git -q -qq -y
RUN /usr/bin/mkdir -p /home/${USERNAME}/data
RUN /usr/bin/chown -R ${USERNAME}:${GRPNAME} /home/${USERNAME}

RUN /usr/bin/echo "${USERNAME}:${PASSWORD}" |/usr/sbin/chpasswd

USER ${USERNAME}
WORKDIR /home/${USERNAME}/

RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv

ENV PATH /home/${USERNAME}/.rbenv/shims:/home/${USERNAME}/.rbenv/bin::$PATH

RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
RUN . ~/.bashrc
RUN rbenv rehash
RUN rbenv install -l
RUN rbenv install ${RUBYVER}
RUN rbenv rehash
RUN rbenv versions
RUN rbenv global ${RUBYVER}

EOF

docker build -t ${IMAGENAME}:${IMAGETAG} .

figlet "script" "finished" "successfully."
echo "If you use docker image please type"
echo "docker run -it --rm \\"
echo "           --mount type=bind,source=${PWD}/data,destination=/home/${USERNAME}/data \\"
echo "           --mount type=bind,source=${PWD}/conf/.ssh,destination=/home/${USERNAME}/.ssh \\"
echo "           --mount type=bind,source=${PWD}/ruby,destination=/home/${USERNAME}/ruby \\"
echo "           --mount type=bind,source=${PWD}/rbenv,destination=/home/${USERNAME}/rbenv  ${IMAGENAME}:${IMAGETAG}"
figlet "Thank you!"

