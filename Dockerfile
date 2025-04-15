FROM ubuntu as baseline

LABEL maintainer="Noah Shaffer" \
      email="noahw@example.com"

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

# Install packages
RUN \
    apt-get update && \
    apt-get install -y \
    traceroute \
    whois \
    host \
    htop \
    dnsutils \
    net-tools \
    figlet \
    tcpdump \
    telnet \
    prips \
    cifs-utils \
    rlwrap \
    iputils-ping \
    git \
    xsltproc \
    rdate \
    zsh \
    curl \
    unzip \
    p7zip-full \
    locate \
    tree \
    openvpn \
    vim \
    wget \
    ftp \
    apache2 \
    squid \
    python3 \
    python3-pip \
    jq \
    libcurl4-openssl-dev \
    libssl-dev \
    nmap \
    masscan \
    netcat \
    cewl \
    dos2unix \
    ssh \
    rsyslog \
    fcrackzip \
    exiftool \
    binwalk \
    foremost \
    sqlite3 \
    # patator dependencies
    libmysqlclient-dev \
    # evil-winrm dependencies
    ruby-full \
    # enum4linux dependencies
    ldap-utils \
    smbclient \
    # john dependencies
    build-essential \
    libssl-dev \
    zlib1g-dev  \
    yasm \
    pkg-config \
    libgmp-dev \
    libpcap-dev \
    libbz2-dev \
    # crackmapexec dependencies
    libffi-dev \
    python-dev

RUN python3 -m pip install --upgrade pip && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y php \
    libapache2-mod-php && \
    gem install \
    gpp-decrypt \
    addressable \
    wpscan \
    # Install evil-winrm
    evil-winrm

FROM baseline as builder
# SERVICES

# Apache configuration
RUN \
    sed -i 's/It works!/It works from container!/g' /var/www/html/index.html && \
# Squid configuration
    echo "http_access allow all" >> /etc/squid/squid.conf && \
    sed -i 's/http_access deny all/#http_access deny all/g' /etc/squid/squid.conf

# Install oh-my-zsh
RUN \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    sed -i '1i export LC_CTYPE="C.UTF-8"' /root/.zshrc && \
    sed -i '2i export LC_ALL="C.UTF-8"' /root/.zshrc && \
    sed -i '3i export LANG="C.UTF-8"' /root/.zshrc && \
    sed -i '3i export LANGUAGE="C.UTF-8"' /root/.zshrc && \
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    git clone --depth 1 https://github.com/zsh-users/zsh-history-substring-search /root/.oh-my-zsh/custom/plugins/zsh-history-substring-search && \
    sed -i 's/plugins=(git)/plugins=(git aws golang nmap node pip pipenv python ubuntu zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)/g' /root/.zshrc && \
    sed -i '78i autoload -U compinit && compinit' /root/.zshrc

# Install python dependencies
COPY requirements_pip.txt /tmp
RUN \
    pip install -r /tmp/requirements_pip.txt

# DEVELOPER TOOLS

# Install go
WORKDIR /tmp
RUN \
    wget -q https://dl.google.com/go/go1.16.2.linux-amd64.tar.gz -O go.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
# Install aws-cli
    curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install && \
# Install node
    curl -sL https://deb.nodesource.com/setup_14.x | bash && \
    apt install -y nodejs
ENV GOROOT "/usr/local/go"
ENV GOPATH "/root/go"
ENV PATH "$PATH:$GOPATH/bin:$GOROOT/bin"

# PORT SCANNING
RUN mkdir -p /tools/portScanning
WORKDIR /tools/portScanning

RUN \
# Download naabu
    mkdir -p /tools/portScanning/naabu
WORKDIR /tools/portScanning/naabu
RUN \
    wget --quiet https://github.com/projectdiscovery/naabu/releases/download/v1.1.4/naabu_1.1.4_linux_amd64.tar.gz -O naabu.tar.gz && \
    tar -xzf naabu.tar.gz && \
    rm naabu.tar.gz && \
    ln -s /tools/portScanning/naabu/naabu /usr/bin/naabu

# RECON
FROM baseline as recon
RUN mkdir /temp
WORKDIR /temp/

# Download whatweb
RUN \
    git clone --depth 1 https://github.com/urbanadventurer/WhatWeb.git && \
# Install dirsearch
    git clone --depth 1 https://github.com/maurosoria/dirsearch.git && \
# Download arjun
    git clone --depth 1 https://github.com/s0md3v/Arjun.git && \
# Download joomscan
    git clone --depth 1 https://github.com/rezasp/joomscan.git && \
# Install massdns
    git clone --depth 1 https://github.com/blechschmidt/massdns.git && \
# Install striker
    git clone --depth 1 https://github.com/s0md3v/Striker.git && \
# Install Photon
    git clone --depth 1 https://github.com/s0md3v/Photon.git && \
# Download linkfinder
    git clone --depth 1 https://github.com/GerbenJavado/LinkFinder.git && \
# Download CMSeeK
    git clone --depth 1 https://github.com/Tuhinshubhra/CMSeeK.git 