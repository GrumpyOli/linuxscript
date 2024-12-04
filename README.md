# GrumpyOli's Script

A collection of useful commands to make your life easier!

---

## 🔧 Prerequisites

### Install Curl
To use some commands, you might need `curl`. Install it with:

```bash
sudo apt install -y curl
```

## 📡 Enabling SSH Server
Follow these steps to enable the SSH server:

Update the package list.
Install the OpenSSH server.
Allow SSH through the firewall.
Run the following commands:

```Bash
sudo apt update
sudo apt install -y openssh-server
sudo ufw allow ssh
```

## MariaDB
### Installation

```Bash
sudo curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash -s
sudo apt install mariadb-server -y
```

`sudo mysql_secure_installation`

### Uninstall

`curl -sSL https://raw.githubusercontent.com/GrumpyOli/linuxscript/refs/heads/main/mariadb_remove.sh | sudo bash`

<h2>Pelican Panel & Wings helper</h2>

<p>Panel</p>

```Bash
cd ~
sudo curl -sSL https://raw.githubusercontent.com/GrumpyOli/linuxscript/refs/heads/main/pelican/panel/install_pelican_panel.sh -O
sudo chmod +x install_pelican_panel.sh
./install_pelican_panel.sh
```
