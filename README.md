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

# Offensive Docker

Offensive Docker is an image with the most commonly used tools to create a penetration testing environment easily and quickly.

## Features

- OS, networking, developing and pentesting tools installed
- Connection to HTB (Hack the Box) VPN to access HTB machines
- Popular wordlists installed
- Proxy service to send traffic from browsers and Burp Suite
- Exploit database installed
- Tools for password cracking
- Linux enumeration tools
- Directory fuzzing tools
- Zsh shell with custom configuration

## Requirements

- Docker service installed

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
printf "\e[1;31m  | |  | | |_| |_ ___ _ __  __| | __   __  | | | | ___   ___| | _____ _ __     \e[0m\n"
printf "\e[1;31m  | |  | |  _|  _/ _ \ '_ \/ _\` | \ \ / /  | | | |/ _ \ / __| |/ / _ \ '__|    \e[0m\n"
printf "\e[1;31m  | |__| | | | ||  __/ | | \(_| |  \ V /   | |_| | (_) | (__|   <  __/ |       \e[0m\n"
printf "\e[1;31m   \____/|_| |_| \___|_| |_\__,_|   \_/    |____/ \___/ \___|_|\_\___|_|       \e[0m\n"
printf "\e[1;31m                                                                                \e[0m\n"
printf "\e[1;31m                                                          by Noah Shaffer       \e[0m\n"
printf "\e[1;31m                                                                                \e[0m\n"
printf "\n"
printf "\e[1;31m    For more information: https://github.com/noahshaffer/offensive-docker        \e[0m\n"
printf "\n"
printf "\e[1;34m[+] Container IP address: \e[0m" && hostname -I
printf "\n"
