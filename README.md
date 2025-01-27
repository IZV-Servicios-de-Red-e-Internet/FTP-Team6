# FTP-Team6 Exercise
## DNS
Before Starting with the DNS configuration, we need to make sure that we have configured our other machines with the correct configuration so they can use the correct DNS server.
In order to do this, is pretty straightforward, we just need to change the file /etc/resolv.conf and add the ip address of the DNS server that we are going to configure.
In the yml file for each host, we have to add this
`
- name: Update resolv.conf to use local DNS
  hosts: all
  become: yes
  tasks:
    - name: Add local DNS to resolv.conf
      lineinfile:
        path: /etc/resolv.conf
        line: "nameserver 192.168.56.10"
        state: present
`
