# GrumpyOli's Script

A collection of useful commands to make your life easier!

---

## 🔧 Prerequisites

### Install Curl
To use some commands, you might need `curl`. Install it with:

```bash
sudo apt install -y curl
```

## Fresh server script
It will instal mDNS and QEMU agent

```Bash
sudo curl -LsS https://raw.githubusercontent.com/GrumpyOli/linuxscript/refs/heads/main/fresh_server_start.sh | sudo bash -s
```

## 📡 Enabling SSH Server
Follow these steps to enable the SSH server:

```Bash
sudo apt update
sudo apt install -y openssh-server
sudo ufw allow ssh
```

---

## 🗄️ MariaDB

### Installation

Follow these steps to install MariaDB:

```Bash
sudo curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash -s
sudo apt install mariadb-server -y
sudo mysql_secure_installation
```

### Uninstall

```Bash
curl -sSL https://raw.githubusercontent.com/GrumpyOli/linuxscript/refs/heads/main/mariadb_remove.sh | sudo bash
```

---

## Pelican Panel & Wings helper

### Panel installation script

```Bash
cd ~
sudo curl -sSL https://raw.githubusercontent.com/GrumpyOli/linuxscript/refs/heads/main/pelican/panel/install_pelican_panel.sh -O
sudo chmod +x install_pelican_panel.sh
./install_pelican_panel.sh
```
