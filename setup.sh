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
echo "[!] NOTE: INSTALLATION HAS BEEN TESTED ON UBUNTU ONLY. RESULTS MAY VARY FOR OTHER DISTRIBUTIONS."

baseDir=$PWD
username="$(logname 2>/dev/null || echo root)"
homeDir=$(eval echo "~$username")

mkdir -p "$toolsDir"
cd "$toolsDir" || { echo "Something went wrong"; exit 1; }


# Golang
go version &> /dev/null
if [ $? -ne 0 ]; then
	echo "[*] Installing Golang and configuring..."
	wget --quiet https://golang.org/dl/go1.15.6.linux-amd64.tar.gz
	tar -C /usr/local -xvf go1.15.6.linux-amd64.tar.gz > /dev/null
	rm -rf go1.15.6.linux-amd64.tar.gz
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

# Python pip install
echo "[*] Installing Python packages"
pip install wfuzz

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

echo "[*] SETUP FINISHED."
exit 0