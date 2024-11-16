<h1>GrumpyOli's Script</h1>

<h2>Basic script for application installation</h2>
<p>Linux basic script, first we need to install Curl to make sure everything works fine</p>

```Bash
sudo apt install curl
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
