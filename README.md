# FTP-Team6
## Local FTP Server

We use a Vagrant file and Ansible config to make the server

First step is in the Ansible file, make the config

```
  - name: Update cache APT
    apt:
      update_cache: yes

  - name: Install vsftpd service
    apt:
      name: vsftpd
      state: present

```

With these lines, we update the repositories and install the vsftpd service in the server

Next step is configurate the vsftpd file to apply the config that we need:

```
  - name: Configure vsftpd file
    copy:
      dest: /etc/vsftpd.conf
      content: |
        listen=YES
        anonymous_enable=NO
        local_enable=YES
        write_enable=YES
        chroot_local_user=YES
        allow_writeable_chroot=YES
        chroot_list_enable=YES
        chroot_list_file=/etc/vsftpd.chroot_list
        ftpd_banner={{ ftp_banner }}
        local_umask=022

  - name: Create chroot list file
    file:
      path: /etc/vsftpd.chroot_list
      state: touch
```

Next step is make the creation of the users that we need

```
  # Creation of the user Charles
  - name: Create Charles user
    ansible.builtin.user:
      name: charles
      password: "{{ '1234' | password_hash('sha512') }}"
      create_home: true

  - name: Create FTP directory for charles
    ansible.builtin.file:
      path: /home/charles/ftp
      state: directory
      owner: charles
      group: charles
      mode: "0755"

  - name: Create shared directory for charles
    ansible.builtin.file:
      path: /home/charles/shared
      state: directory
      owner: charles
      group: charles
      mode: "0700"

  - name: Add charles to chroot List
    ansible.builtin.lineinfile:
      path: /etc/vsftpd.chroot_list
      line: charles

  # Creation of the user laura
  - name: Create laura user
    ansible.builtin.user:
      name: laura
      password: "{{ '1234' | password_hash('sha512') }}"
      create_home: true

  - name: Create FTP Directory for laura
    ansible.builtin.file:
      path: /home/laura/ftp
      state: directory
      owner: laura
      group: laura
      mode: "0755"

  - name: Create Shared directory for laura
    ansible.builtin.file:
      path: /home/laura/shared
      state: directory
      owner: laura
      group: laura
      mode: "0755"

  - name: Add laura to chroot list
    ansible.builtin.lineinfile:
      path: /etc/vsftpd.chroot_list
      line: laura
      state: absent
```

With that we make the user, shared directory and add to chroot list
