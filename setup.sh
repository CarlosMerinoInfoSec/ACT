#!/bin/bash
## Setup script
## By Carlos Merino contact@carlosmerino.org

# Run as root or exit
if [ "$EUID" -ne 0 ]
then
  echo "[-] Installation requires elevated privileges, please run as root"
  exit 1
fi

for arg in "$@"
do
    case $arg in
        -h|--help)
        echo "AnotherConsolidatedTool Installer"
        echo " "
        echo "$0 [options]"
        echo " "
        echo "options:"
        echo "-h, --help                show help"
        echo "-t, --toolsdir            tools directory, defaults to '/opt'"
        echo ""
        echo "Note: If you choose a non-default tools directory, pass the -t flag to ensure it finds the right tools."
        echo ""
        echo "example:"
        echo "$0 -t /opt"
        exit 0
        ;;
        -t|--toolsdir)
        toolsDir="$2"
        shift
        shift
        ;;
    esac
done

if [ -z "$toolsDir" ]
then
    toolsDir="/opt"
fi

echo "[*] INSTALLING DEPENDENCIES IN \"$toolsDir\"..."
echo "[!] NOTE: INSTALLATION HAS ONLY BEEN TESTED ON UBUNTU."

baseDir=$PWD
username="$(logname 2>/dev/null || echo root)"
homeDir=$(eval echo "~$username")

mkdir -p "$toolsDir"
cd "$toolsDir" || { echo "Something went wrong"; exit 1; }

# Apt-get stuff
apt-get install figlet

# Golang
go version &> /dev/null
if [ $? -ne 0 ]; then
	echo "[*] Installing Golang and configuring..."
	wget --quiet https://golang.org/dl/go1.15.6.linux-amd64.tar.gz
	tar -C /usr/local -xvf go1.15.6.linux-amd64.tar.gz > /dev/null
	rm -rf go1.15.6.linux-amd64.tar.gz
	rm -rf go
	export GOROOT="/usr/local/go"
	export PATH=$PATH:/usr/local/go/bin
else
	echo "[*] Golang already installed."
fi

# Go packages
echo "[*] Getting Go packages"
go get -u github.com/jaeles-project/gospider &>/dev/null
go get -u github.com/haccer/subjack &>/dev/null
go get github.com/OJ/gobuster &>/dev/null

# Ruby
ruby -v &> /dev/null
if [ $? -ne 0 ]; then
        echo "[*] Installing Ruby and gems..."
        apt-get install ruby-full
        gem install bundler
else
        echo "[*] Ruby and gems already installed."
fi

# Python pip install
echo "[*] Installing Python packages"
pip install -r /root/requirements.txt
pip install wfuzz

# WhatWeb package commenting out due to python running ruby issue
#echo "[*] Installing WhatWeb..."
#wget --quiet https://github.com/urbanadventurer/WhatWeb/archive/v0.5.5.tar.gz
#tar -xvf v0.5.5.tar.gz > /dev/null
#rm -rf v0.5.5.tar.gz
#cd WhatWeb-0.5.5
#make install
#mv whatweb /usr/local/bin/
#cd ..

#wafw00f
echo "[*] Installing wafw00f..."
git clone https://github.com/EnableSecurity/wafw00f.git
cd wafw00f/
python3 setup.py install
cd ..

# HTTPX
echo "[*] Installing HTTPX..."
wget https://github.com/projectdiscovery/httpx/releases/download/v1.0.3/httpx_1.0.3_linux_amd64.tar.gz -q
tar xvf httpx_1.0.3_linux_amd64.tar.gz -C /usr/bin/ httpx >/dev/null
rm httpx_1.0.3_linux_amd64.tar.gz

# Amass
echo "[*] Installing Amass..."
wget https://github.com/OWASP/Amass/releases/download/v3.11.1/amass_linux_amd64.zip -q
unzip -q amass_linux_amd64.zip
mv amass_linux_amd64 amass
rm amass_linux_amd64.zip
cp $toolsDir/amass/amass /usr/bin/amass

# Back to /root
cd "$baseDir" || { echo "Something went wrong"; exit 1; }

# Move Go downloads to /opt/go
mv go/ /opt/go

# Repos test
git clone https://github.com/aboul3la/Sublist3r.git
mv Sublist3r/ /opt/Sublist3r
git clone https://github.com/faizann24/XssPy.git
mv XssPy/ /opt/XssPy
git clone https://github.com/m4ll0k/Infoga.git
mv Infoga/ /opt/Infoga
git clone https://github.com/GerbenJavado/LinkFinder.git
mv LinkFinder/ /opt/LinkFinder
git clone https://github.com/s0md3v/Striker.git
mv Striker/ /opt/Striker
git clone https://github.com/Tuhinshubhra/CMSeeK.git
mv CMSeeK/ /opt/CMSeek

#theHarvester
git clone https://github.com/laramies/theHarvester
cd theHarvester
python3 -m pip install -r requirements/base.txt
sed -i 's+/usr/local/etc/theHarvester/proxies.yaml+/root/theHarvester/proxies.yaml+g' /root/theHarvester/theHarvester/lib/core.py
cd ..
mv theHarvester/ /opt/

# Create wordlist directory and pull down wordlist
mkdir /usr/share/wordlists
wget -O /usr/share/wordlists/directory-list-2.3-medium.txt https://raw.githubusercontent.com/CarlosMerinoInfoSec/Wordlists/master/directory-list-2.3-medium.txt

echo "[*] SETUP FINISHED."
exit 0