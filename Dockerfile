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
    sqlite3

RUN python3 -m pip install --upgrade pip

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