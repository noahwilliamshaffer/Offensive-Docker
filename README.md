<!-- markdownlint-disable MD033 MD041 -->

<p align="center">
  <a href="https://hub.docker.com/r/noahshaffer/offensive-docker">
    <img
      alt="Offensive Docker"
      src="https://github.com/noahshaffer/offensive-docker/blob/master/img/banner.jpg"
      width="600"
    />
  </a>
</p>
<br/>
<p align="center">
  <a href="https://github.com/noahshaffer/offensive-docker"><img alt="GitHub code size in bytes" src="https://img.shields.io/github/languages/code-size/noahshaffer/offensive-docker"></a>
  <a href="https://github.com/noahshaffer/offensive-docker"><img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/noahshaffer/offensive-docker"></a>
  <a href="https://github.com/noahshaffer/offensive-docker"><img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/noahshaffer/offensive-docker"></a>
  <a href="https://github.com/noahshaffer/offensive-docker"><img alt="GitHub issues" src="https://img.shields.io/github/issues/noahshaffer/offensive-docker"></a>
  <a href="https://github.com/noahshaffer/offensive-docker/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/noahshaffer/offensive-docker">
  <a href="https://github.com/noahshaffer/offensive-docker/blob/master/LICENSE"><img alt="GitHub" src="https://img.shields.io/github/license/noahshaffer/offensive-docker"></a>
</p>

# Offensive Docker

Offensive Docker is an image with the most commonly used tools to create a penetration testing environment easily and quickly.

### Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Tools Installed](#tools-installed)
  - [Operating System Tools](#operating-system-tools)
  - [Network Tools](#network-tools)
  - [Developer Tools](#developer-tools)
  - [Offensive Tools](#offensive-tools)
    - [Port Scanning](#port-scanning)
    - [Reconnaissance](#reconnaissance)
    - [Web Scanning](#web-scanning)
    - [CMS Tools](#cms-tools)
    - [JavaScript Analysis](#javascript-analysis)
    - [Wordlists](#wordlists)
    - [Brute Force](#brute-force)
    - [Exploitation](#exploitation)
  - [Custom Functions](#custom-functions)
- [Usage](#usage)
  - [Option 1 - Use the Docker Hub Image](#option-1---use-the-docker-hub-image)
  - [Option 2 - Build from Source](#option-2---build-from-source)
  - [Running the Container](#running-the-container)
- [Advanced Configurations](#advanced-configurations)
  - [Configuring Credentials](#configuring-credentials)
  - [Connecting to HTB VPN](#connecting-to-htb-vpn)
  - [Saving Command History](#saving-command-history)
- [Tested Environments](#tested-environments)
- [Warning](#warning)
- [Contributing](#contributing)
- [License](#license)

## Features

- OS, networking, developing and pentesting tools installed
- Connection to HTB (Hack the Box) VPN to access HTB machines
- Popular wordlists installed (SecLists, dirb, dirbuster, fuzzdb, wfuzz, rockyou)
- Proxy service to send traffic from browsers and Burp Suite
- Exploit database installed
- Password cracking tools
- Linux enumeration tools
- Directory fuzzing tools
- Custom shell configuration with ZSH

## Requirements

- Docker service installed

## Tools Installed

### Operating System Tools

- vim
- zsh with oh-my-zsh
- locate
- cifs-utils
- htop
- tree
- rdate
- fcrackzip

### Network Tools

- traceroute
- telnet
- net-tools
- iputils-ping
- tcpdump
- openvpn
- whois
- host
- prips
- dig

### Developer Tools

- git
- curl
- wget
- ruby
- go
- python3
- python3-pip
- php
- aws-cli
- nodejs

### Offensive Tools

#### Port Scanning

- nmap
- masscan
- naabu

#### Reconnaissance

- Amass
- GoBuster
- MassDNS
- Sublist3r
- subfinder
- spiderfoot
- hakrevdns
- gowitness
- aquatone
- hakrawler
- Photon
- gospider
- gau
- waybackurls
- dirsearch
- wfuzz
- ffuf

#### Web Scanning

- whatweb
- nikto
- arjun
- httprobe
- striker
- httpx

#### CMS Tools

- wpscan
- joomscan
- droopescan
- cmseek

#### JavaScript Analysis

- LinkFinder
- getJS
- subjs

#### Wordlists

- SecLists
- fuzzdb
- dirbuster
- rockyou

#### Brute Force

- hydra
- medusa
- patator

#### Exploitation

- Metasploit Framework
- searchsploit
- evil-winrm

### Custom Functions

The container includes some useful custom functions:

- `updateTools`: Updates all the installed Git repositories to their latest versions

## Usage

### Option 1 - Use the Docker Hub Image

```bash
docker pull noahshaffer/offensive-docker
docker run -it --rm noahshaffer/offensive-docker
```

### Option 2 - Build from Source

```bash
git clone https://github.com/noahshaffer/offensive-docker.git
cd offensive-docker
docker build -t offensive-docker .
docker run -it --rm offensive-docker
```

### Running the Container

Run the container with different configurations:

**Basic Usage:**
```bash
docker run -it --rm noahshaffer/offensive-docker
```

**With HTB VPN:**
```bash
docker run -it --rm --cap-add=NET_ADMIN --device=/dev/net/tun --sysctl net.ipv6.conf.all.disable_ipv6=0 -v $(pwd)/hackthebox:/root/hackthebox noahshaffer/offensive-docker
```

**With Shared Folder:**
```bash
docker run -it --rm -v $(pwd)/shared:/root/shared noahshaffer/offensive-docker
```

**With Command History:**
```bash
docker run -it --rm -v $(pwd)/.zsh_history:/root/.zsh_history noahshaffer/offensive-docker
```

## Advanced Configurations

### Configuring Credentials

To save your credentials inside the container:

```bash
# Inside the container
echo 'export AWS_ACCESS_KEY_ID="your_access_key"' >> ~/.zshrc
echo 'export AWS_SECRET_ACCESS_KEY="your_secret_key"' >> ~/.zshrc
echo 'export SHODAN_API_KEY="your_shodan_key"' >> ~/.zshrc
```

### Connecting to HTB VPN

1. Place your HTB VPN file in a local directory
2. Mount that directory when running the container
3. Inside the container, connect to the VPN:

```bash
cd ~/hackthebox
openvpn your_htb_vpn_file.ovpn
```

### Saving Command History

To persist command history between container runs:

```bash
docker run -it --rm -v $(pwd)/.zsh_history:/root/.zsh_history noahshaffer/offensive-docker
```

## Tested Environments

- Docker for Linux
- Docker for Windows
- Docker for Mac

## Warning

This tool is designed for educational purposes and legal penetration testing activities. Always ensure you have proper authorization before testing any systems. Using these tools against systems without permission is illegal and unethical.

## Contributing

Contributions are welcome! Please check out our [Contributing Guidelines](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```bash
#!/bin/bash

updateTools(){
    echo "Updating tools..."
    cd /opt/dirsearch && git pull
    cd /opt/joomscan && git pull
    cd /opt/Striker && git pull
    cd /opt/Photon && git pull
    cd /opt/LinkFinder && git pull
    cd /opt/CMSeeK && git pull
    cd /opt/Sublist3r && git pull
    echo "Tools updated!"
}
```

```bash
#!/bin/bash

printf "\n"
printf "\e[1;31m    ____   __  __                _            ____             _                 \e[0m\n"
printf "\e[1;31m   / __ \ / _|/ _|            | |          |  _ \           | |                \e[0m\n"
printf "\e[1;31m  | |  | | |_| |_ ___ _ __  __| | \ \ / /  | | | | ___   ___| | _____ _ __     \e[0m\n"
printf "\e[1;31m  | |  | |  _|  _/ _ \ '_ \/ _\` |  \ V /   | | | |/ _ \ / __| |/ / _ \ '__|    \e[0m\n"
printf "\e[1;31m  | |__| | | | ||  __/ | | \(_| |   \_/    | |_| | (_) | (__|   <  __/ |       \e[0m\n"
printf "\e[1;31m   \____/|_| |_| \___|_| |_\__,_|   \_/    |____/ \___/ \___|_|\_\___|_|       \e[0m\n"
printf "\e[1;31m                                                                                \e[0m\n"
printf "\e[1;31m                                                          by Noah Shaffer       \e[0m\n"
printf "\e[1;31m                                                                                \e[0m\n"
printf "\n"
printf "\e[1;31m    For more information: https://github.com/noahshaffer/offensive-docker        \e[0m\n"
printf "\n"
printf "\e[1;34m[+] Container IP address: \e[0m" && hostname -I
printf "\n"
