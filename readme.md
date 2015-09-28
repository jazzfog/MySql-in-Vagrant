MySQL with persistent data inside VM provisioned with Vagrant
=============================================================

This project contains Vagrant config file and couple of bash scripts which will create virtual machine containing MySQL with data files located in synced folder on host machine.

It means you can `vagrant destroy` and `vagrant up` as many times as you need and MySQL data will still be there.

This project features
---------------------
- Virtual machine, provisioned with help of Vagrant, containing MySQL.
- MySQL install in non-interactive mode.
- As said above, the MySQL data is persistent - you can destroy and re-create VM without losing the data in your DB.
- Setup of access to your MySQL server from host machine.
- Apt-get `update` and `dist-upgrade` in non-interactive mode.

How to use
----------

1. Install [VirtualBox](https://www.virtualbox.org) virtualizer so you could run virtual machines on your desktop.
2. Install [Vagrant](https://www.vagrantup.com) provisioner so you could create VMs in easier way.
3. Get this project files by cloning with `git` executing `git clone https://github.com/jazzfog/mysql-in-vagrant.git` from console or just [download zip file](https://github.com/jazzfog/mysql-in-vagrant/archive/master.zip).
4. Open directory with files in console and execute `vagrant up`.
5. Just wait, in couple of minutes you will have fully functional MySQL server in virtual machine.
6. Connect to it from your desktop using ip and port `192.168.100.120:3306` (you can change it in `Vagrantfile`). By default there is only user `root` with empty password.
7. Log in into your VM with MySQL by running `vagrant ssh` in console from directory where project files are. Or you can use any `ssh` client you prefer and connect using ip and port `192.168.100.120:22`, in this case use login `vagrant` and password `vagrant` to access VM.
8. Connect to MySQL server from VM by running `mysql -u root` in console (no need to use key `-p`)

Facts
-----
- To connect use login `root` and empty password. You can [create more users](https://www.google.com/search?q=site:stackoverflow.com+mysql+how+to+create+user) using it.
- This instance supposed to be development environment. The fact that root password is empty should state it :)
- However it may give you some ideas how to provision production server automatically.
- The data (MySQL binary files are located in directory `MysqlData` inside project folder). After each start MySQL in VM will pickup those files.
- If you want to reset data - just delete directory `MysqlData`.
- Guest OS/box is "[ubuntu/trusty64](https://atlas.hashicorp.com/ubuntu/boxes/trusty64)"
- VM login and password are default for Vagrant: `vagrant`/`vagrant`.