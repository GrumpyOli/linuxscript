<h1>GrumpyOli's Script</h1>

<h2>Basic script for application installation</h2>
<p>Linux basic script, first we need to install Curl to make sure everything works fine</p>

```Bash
sudo apt install curl
```
<p>Enabling SSH Server</p>

```Bash
sudo apt update -q
sudo apt install -y -q openssh-server
sudo ufw allow ssh
```
<h2>MariaDB</h2>
<p>Install script</p>

```Bash
curl -sSL https://raw.githubusercontent.com/GrumpyOli/linuxscript/refs/heads/main/mariadb.sh | sudo bash
```

<p>Uninstall script</p>

```Bash
curl -sSL https://raw.githubusercontent.com/GrumpyOli/linuxscript/refs/heads/main/mariadb_remove.sh | sudo bash
```

<h2>Pelican Panel & Wings helper</h2>

<p>First, we ..</p>

```Bash
curl -sSL https://raw.githubusercontent.com/GrumpyOli/linuxscript/refs/heads/main/pelican/panel/setup_database.sh | sudo bash
```
