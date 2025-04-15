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
    git clone --depth 1 https://github.com/Tuhinshubhra/CMSeeK.git && \
# Install aquatone
    wget --quiet https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip -O aquatone.zip && \
    unzip aquatone.zip -d aquatone  && \
    rm aquatone.zip && \
# Install amass
    wget --quiet https://github.com/OWASP/Amass/releases/download/v3.10.5/amass_linux_amd64.zip -O amass.zip && \
    unzip amass.zip -d amass && \
    rm amass.zip && \
# Download Sublist3r
    git clone --depth 1 https://github.com/aboul3la/Sublist3r.git && \
# Download spiderfoot
    git clone --depth 1 https://github.com/smicallef/spiderfoot && \
    mkdir /temp/gowitness && \
    mkdir /temp/subfinder && \
    mkdir /temp/findomain && \
    mkdir /temp/gau

# Install Go tools
FROM baseline as gotools
WORKDIR /tmp

# Install gowitness
RUN \
    go install github.com/sensepost/gowitness@latest && \
# Install subjack
    go install github.com/haccer/subjack@latest && \
# Install SubOver
    go install github.com/Ice3man543/SubOver@latest && \
# Install gobuster
    go install github.com/OJ/gobuster/v3@latest && \
# Install subfinder
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
# Install hakrawler
    go install github.com/hakluke/hakrawler@latest && \
# Install gospider
    go install github.com/jaeles-project/gospider@latest && \
# Install httprobe
    go install github.com/tomnomnom/httprobe@latest && \
# Install tko-subs
    go install github.com/anshumanbh/tko-subs@latest && \
# Install hakrevdns
    go install github.com/hakluke/hakrevdns@latest && \
# Install haktldextract
    go install github.com/hakluke/haktldextract@latest && \
# Install hakcheckurl
    go install github.com/hakluke/hakcheckurl@latest && \
# Install ffuf
    go install github.com/ffuf/ffuf@latest && \
# Install subjs
    go install github.com/lc/subjs@latest && \
# Install gau
    go install github.com/lc/gau/v2/cmd/gau@latest && \
# Install httpx
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest && \
# Install otxurls
    go install github.com/lc/otxurls@latest && \
# Install waybackurls
    go install github.com/tomnomnom/waybackurls@latest && \
# Install getJS
    go install github.com/003random/getJS@latest

# Install wordlists
FROM baseline as wordlists
WORKDIR /wordlists

# Download SecLists
RUN \
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git && \
# Download fuzzdb
    git clone --depth 1 https://github.com/fuzzdb-project/fuzzdb.git && \
# Download dirbuster
    mkdir -p /wordlists/dirbuster && \
    wget -q https://sourceforge.net/projects/dirbuster/files/DirBuster%20Lists/Current/DirBuster-Lists.tar.bz2/download -O /wordlists/dirbuster/DirBuster-Lists.tar.bz2 && \
    tar -xjf /wordlists/dirbuster/DirBuster-Lists.tar.bz2 -C /wordlists/dirbuster && \
    rm /wordlists/dirbuster/DirBuster-Lists.tar.bz2

# Download rockyou
RUN \
    mkdir -p /wordlists/rockyou && \
    wget -q https://github.com/praetorian-inc/Hob0Rules/raw/master/wordlists/rockyou.txt.gz -O /wordlists/rockyou/rockyou.txt.gz && \
    gunzip /wordlists/rockyou/rockyou.txt.gz

# FINAL IMAGE
FROM baseline

# Copy shell customization
COPY shell/customFunctions /root/.customFunctions
COPY shell/banner /root/.banner
COPY shell/alias /root/.alias

RUN \
# Add custom functions to .zshrc
    echo 'source /root/.customFunctions' >> /root/.zshrc && \
# Add alias to .zshrc
    echo 'source /root/.alias' >> /root/.zshrc && \
# Invoke motd banner when opening the terminal
    echo '/root/.banner' >> /root/.zshrc && \
# Add paths
    echo 'export PATH="$PATH:/usr/local/go/bin:/root/go/bin"' >> /root/.zshrc

# Expose proxy ports
EXPOSE 80 3128

# Create tools folder
RUN mkdir -p /tools

# Start services when running the container
CMD service apache2 start && service squid start && /bin/zsh 