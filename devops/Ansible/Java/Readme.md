Install Java on Ubuntu 20.04 and Centos 7
-------------------------------------------
* Lets try to install java on ubuntu and centos machines.
* Before we have to write a playbook we should follow the commands manually whether its working or not.
* [Refer here](https://linuxize.com/post/install-java-on-ubuntu-20-04/) for java installation commands on ubuntu

```
sudo apt update
sudo apt install openjdk-11-jdk
java -version
```
* Also for installing java on centos [Refer here](https://linuxize.com/post/install-java-on-centos-7/).

```
sudo yum install java-11-openjdk-devel
java -version
```

### Playbook

* To install java on both machines is looking very easy.
* But for writing a playbook Java installation in Ubuntu and Centos facing a difficulty because of different package managers.
* Package managers might be different, ansible has a module called package.
* Then create variables on inventory with respect to package names.
* In inventory the variables can be written in two formats i.e., ini file format, yaml format.
* But the variables in inventory is not a good idea.
* lets execute the following playbook 
---
```yml
- name: install openjdk on ubuntu 20.04 and Centos 7
  hosts: all
  become: yes
  tasks:
    - name: java installation
      ansible.builtin.package:
        name: "{{ java_package_name }}"
        state: present
```        
---
```ini
[appservers]
20.203.177.158 java_package_name=java-11-openjdk-devel
20.248.203.102 java_package_name=openjdk-11-jdk
```
* Now create roles and copy the playbook whatever we finished till according to respective folders in roles.

```yml
- name: install java
  hosts: all
  become: yes
  roles:
    - java
```    