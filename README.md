# FTP-Team6
### FTP Server configuration with security

### Configured Virtual Machines: FTP SSL/TLS Server

- **Hostname:** `ftp-ssl-tls`
- **IP:** `192.168.56.14`
- **Description:** Configured with a self-signed SSL certificate for secure connections.

---

### Usage Instructions

#### 1. Initialize the Virtual Machines

Run the following commands to start the virtual machines:

```bash
vagrant up
```

This will bring up the virtual machines defined in the `Vagrantfile`.

#### 2. Access the Machines

You can access the machines using SSH:

```bash
vagrant ssh <machine-name>
```

**Examples:**

```bash
vagrant ssh dns_server
vagrant ssh ftp_anonymous
```

#### 3. Verify the Configuration

- **a) FTP SSL/TLS Server**

  Check the secure connection to the FTP server:

  ```bash
  openssl s_client -connect 192.168.56.11:21 -starttls ftp
  ```

- **b) Anonymous FTP Server**

  Connect to the anonymous FTP server:

  ```bash
  ftp 192.168.56.11
  ```
---

## Troubleshooting

1. **Error Installing Ansible**:

   - Ensure the `instal_ansible.sh` script ran successfully.
   - Verify the internet connection on the affected machine.

2. **FTP SSL/TLS Connection Failure**:

   - Ensure port 21 is open.
   - Verify the SSL certificate:
     ```bash
     openssl s_client -connect 192.168.56.11:21 -starttls ftp
     ```

3. **Network Issues**:

   - Verify that the machines are on the same private network configured in the `Vagrantfile`.
   - Test connectivity with `ping`:
     ```bash
     ping 192.168.56.10
     ```
---
Thankss!!
