[![CircleCI](https://dl.circleci.com/status-badge/img/circleci/XcfWh7FX5QpFKWFb9rXqFw/FLcsVXkxfSayfiYa6doBbG/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/circleci/XcfWh7FX5QpFKWFb9rXqFw/FLcsVXkxfSayfiYa6doBbG/tree/main)

# kali-headful-docker

A Docker container running a headful Kali Linux Default install via RDP

## Defaults  

Default package level installed is Kali Default, if there becomes a demand/interest for containers with the other package levels, I may build other.  

Default login is:  
User: kali  
Pass: toor  

## How to use

Please check the docker-compose.yml sample for an example to start the container. Then you can connect over RDP or SSH to use.  

## Notes  
- `cap_add: SYS_ADMIN` and `seccomp`/`apparmor` unconfined are required, otherwise GTK's sandboxed icon loader (bwrap) fails and the XFCE panel crashes, leaving a blank desktop  
- The desktop can take a little bit to load on first start  
