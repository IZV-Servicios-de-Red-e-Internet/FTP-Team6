# FTP-Team6 Exercise
## DNS
### Starting Configuration
Before Starting with the DNS configuration, we need to make sure that we have configured our other machines with the correct configuration so they can use the correct DNS server.
In order to do this, is pretty straightforward, we just need to change the file /etc/resolv.conf and add the ip address of the DNS server that we are going to configure.
In the yml file for each host, we have to add this
```
- name: Update resolv.conf to use local DNS
  hosts: all
  become: yes
  tasks:
    - name: Add local DNS to resolv.conf
      lineinfile:
        path: /etc/resolv.conf
        line: "nameserver 192.168.56.10"
        state: present
```
Once we have that done, we can start configuring the DNS server

### Configuration of the DNS server (playbook)
We first need to update the repositories of the apt packet manager cache.
```
  hosts: all
  become: true
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
```
When we have that we have to install the service that is going to be used to manage the dns server, it is called bind9
```
 name: Install BIND9
      apt:
        name: bind9
        state: present
```
We now have to create the folder to store all of our configuration files
```
- name: Create zones directory
      file:
        path: /etc/bind/zones
        state: directory
        owner: bind
        group: bind
```
Then we need to copy the configuration files into the dns machine, this files will be explained in the next section, because we have them stored n a folder called **DNS_Config**, we have to make sure that we specify the correct folder.
```
- name: Copy named.conf.local
      copy:
        src: DNS_Config/dnsfiles/named.conf.local
        dest: /etc/bind/named.conf.local

    - name: Copy named.conf.options
      copy:
        src: DNS_Config/dnsfiles/named.conf.options
        dest: /etc/bind/named.conf.options

    - name: Copy forward zone file
      copy:
        src: DNS_Config/dnsfiles/db.sri.ies
        dest: /etc/bind/zones/db.sri.ies
        owner: bind
        group: bind
```
And to finish we have to restart BIND9 so every configuration file applies to the current configuration
```
    - name: Restart BIND9 service
      service:
        name: bind9
        state: restarted
```
### Configuration files
We have provisioned the configuration files in the playbook, now we need to actually write them.
#### db.sri.ies
This file defines how the DNS server has to translate the domain names into ips
```
$TTL 604800
@       IN      SOA     ns.sri.ies. admin.sri.ies. (
                        2025011501 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL
;

@       IN      NS      ns.sri.ies.
ns      IN      A       192.168.1.1
mirror  IN      A       192.168.1.2
ftp     IN      A       192.168.1.3
```
#### named.conf.local
This file is made to define the zone, what type of dns server the machine is and where the dns zone files are located
```
zone "sri.ies" {
    type master;
    file "/etc/bind/zones/db.sri.ies";
};
```
#### named.conf.options
This file is made to define the options of our DNS server, the **directory** option is to specify where the bind instalation is, the **forwarders** option functions so the dns server knows where to rerout their dns queries in case the specified query is not in the local dns server, for example, if im looking for google.com, and my dns server doesnt have it, it can rerout the query to one of the DNS servers specified in the forwarders option, the **recursion** option is enabled with the *yes* option so we can allow for recursive queries, we allowed recursion from any ip with **allow-recursion { any; };** we enhace the security of the dns server with the **dnssec-validation auto;** option, and we allow any ipv4 or ipv6 respectively to listen with the **listen-on { any; };** and **listen-on-v6 { any; };** option.
```
options {
    directory "/var/cache/bind";
    forwarders {
        8.8.8.8;
        1.1.1.1;
    };
    recursion yes;
    allow-recursion { any; }; 
    dnssec-validation auto;
    listen-on { any; };
    listen-on-v6 { any; };
};
```
