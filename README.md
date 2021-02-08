# AnotherConsolidatedTool

A Bash script and Docker image for web app hacking or recon on a target can be used for Bug Bounties.  Low on resources.

## Description

> ⚠ Note: This tool is still a work in progress.

> ⚠ Note:  You should probably use this tool over a VPN.  VPN recommended.

You can run the script as a docker image I have not completed testing on a complete install of Debian/Ubuntu.  Run the setup.sh script and it will download and install all necessary packages.  Then use python3 to run the act.py script and choose what you want to do.

## Installation

### Docker

Docker Hub Link: https://hub.docker.com/r/carlosmerinoinfosec/act

You can pull the Docker image from Docker Hub as below.

```
docker pull carlosmerinoinfosec/act
```

You can also build the image from source

```
git clone https://github.com/CarlosMerinoInfoSec/ACT.git
cd AnotherConsolidatedTool
docker build .
```

### Manual

If you prefer running the script manually, you can do so.

> ℹ Note: The script has been built on -and tested for- Ubuntu 20.04 but it should work on most Debian-based installs (such as Kali Linux).

```
git clone https://github.com/CarlosMerinoInfoSec/ACT.git
cd AnotherConsolidatedTool
chmod +x setup.sh
./setup.sh
python3 act.py --help
python3 act.py -s target.com -do
```

Use '-h' or '--help' for the help menu

```
root@dockerhost:~# python3 act.py
    ___   ____________
   /   | / ____/_  __/
  / /| |/ /     / /
 / ___ / /___  / /
/_/  |_\____/ /_/

    Another Consolidated Tool Created by Carlos Merino

usage: act.py [-h] -s S [-d] [-bg] [-e] [-fd] [-b] [-vscan] [-lf] [-xs] [-pscan] [-ssl]

Passive & Active Recon and OSINT-based Tool

optional arguments:
  -h, --help  show this help message and exit

Passive Reconnaissance Options:
  -s S        The target site or domain on which recon has to be performed
  -d          Perform DNS lookup and find SPF records if available on the target
  -bg         Perform banner grabbing, WAF detection, and find subdomains if any on the target
  -e          Use google dorking to gather any publicly available email ids related to the domain
  -fd         A full DNS scan for all DNS records available on the target

Active/Aggressive Reconnaissance Options:
  -b          Brute force directory listings on the target
  -vscan      Initiate vulnerability scanning on the target
  -lf         Find any links on the target that could be potential endpoints for attack
  -xs         Start an XSS vulnerability scan on the target
  -pscan      Run a fast port scanner on the target
  -ssl        Run a scanner to find SSL related vulnerabilities

EXAMPLES:
------------------------------------------------------------------------------------------------------------------
act.py -s hackerone.com -d        # Perform DNS lookup and find SPF records if any, on the target
act.py -s hackerone.com -bg        # Banner grabbing, WAF detection, crawl for subdomains on the target
act.py -s hackerone.com -e        # Use Google dorking and OSINT to gather publicly emails related to the domain
act.py -s hackerone.com -bg        # Run a scan for banner grabbing and a CMS scan
act.py -s hackerone.com -xs        # Run an XSS vulnerability scan on the target
act.py -s hackerone.com -b        # Run a directory bruteforcing attack on the target
act.py -s hackerone.com -pscan        # Run a fast port scanner on the target
You can even add https:// or http:// to the target site
------------------------------------------------------------------------------------------------------------------
```

### Tools
Have to update this with what's actually being used