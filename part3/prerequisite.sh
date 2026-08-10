if [ $(whoami) != "root" ]; then
	echo -e "\e[31mprerequisite install script must be ran as root\e[0m";
	exit 1;
fi

apt remove $(dpkg --get-selections docker.io docker-compose docker-doc docker-buildx podman-docker containerd runc | cut -f1)
# Add Docker's official GPG key:
apt update
apt install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

apt update
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl start docker
if  ! systemctl is-active --quiet docker ; then
	echo "docker setup failed"
	exit 1;
fi
echo "\e[32mdocker install sucessfully done, now installing k3d\e[0m"
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
usermod -aG docker $1
sleep 4; echo reboot
