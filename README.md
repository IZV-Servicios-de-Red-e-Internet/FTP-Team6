# FTP Anonymous (Javier Caldevilla)
# Playbook de Ansible para Instalar y Configurar un Servidor FTP (vsftpd)

Este repositorio contiene un playbook de Ansible que automatiza la instalación y configuración de un servidor FTP utilizando `vsftpd`. El playbook está diseñado para configurar un servidor FTP que permita conexiones anónimas con ciertas restricciones de seguridad.

## Descripción del Playbook

El playbook realiza las siguientes tareas:

1. **Instalación de vsftpd**: Instala el paquete `vsftpd` en los servidores especificados.
2. **Habilitación del servicio vsftpd**: Habilita y inicia el servicio `vsftpd`.
3. **Creación de un directorio compartido para FTP**: Crea un directorio público en `/var/ftp/pub` con permisos adecuados para usuarios anónimos.
4. **Configuración de vsftpd para conexiones anónimas**: Habilita el acceso anónimo y deshabilita el acceso para usuarios locales.
5. **Restricciones de permisos para usuarios anónimos**: Deshabilita la capacidad de subir archivos y crear directorios para usuarios anónimos.
6. **Configuración de tiempo de espera de conexión**: Establece un tiempo de espera de 30 segundos para las conexiones inactivas.
7. **Limitación de velocidad de transferencia**: Limita la velocidad de transferencia para usuarios anónimos a 5 KB/s.
8. **Configuración del mensaje de bienvenida**: Establece un mensaje de bienvenida para los usuarios que se conectan al servidor FTP.
9. **Creación de un archivo de arte ASCII**: Crea un archivo de bienvenida en el directorio público.
10. **Reinicio del servicio vsftpd**: Reinicia el servicio para aplicar las configuraciones.

Además, el playbook incluye tareas para probar la configuración del servidor FTP, verificando que las conexiones en modo activo y pasivo funcionen correctamente, que los permisos de directorio sean de solo lectura, y que las limitaciones de velocidad y tiempo de espera estén aplicadas.

## Estructura del Playbook

El playbook está dividido en dos secciones principales:

1. **Instalación y configuración de vsftpd**:
   - **Instalación de vsftpd**: Instala el paquete `vsftpd` y actualiza la caché de paquetes.
   - **Habilitación del servicio**: Habilita e inicia el servicio `vsftpd`.
   - **Creación del directorio compartido**: Crea un directorio público con permisos adecuados.
   - **Configuración de vsftpd**: Modifica el archivo de configuración `/etc/vsftpd.conf` para permitir conexiones anónimas, deshabilitar el acceso de usuarios locales, y aplicar restricciones de seguridad.
   - **Reinicio del servicio**: Reinicia el servicio para aplicar los cambios.

2. **Pruebas de configuración**:
   - **Pruebas de conexión FTP**: Verifica que las conexiones en modo activo y pasivo funcionen correctamente.
   - **Verificación de permisos**: Comprueba que los permisos del directorio público sean de solo lectura.
   - **Verificación de velocidad de transferencia**: Confirma que la velocidad de transferencia esté limitada a 5 KB/s.
   - **Verificación de tiempo de espera**: Asegura que el servidor cierre la conexión después de 30 segundos de inactividad.

## Comandos y Tareas Explicados

- **Instalación de vsftpd**:
  ```yaml
  - name: Install vsftpd
    apt:
      name: vsftpd
      state: present
      update_cache: yes
  ```
- **Habilitación del servicio**:
  ```yaml
  - name: Enable vsftpd service
  systemd:
    name: vsftpd
    enabled: yes
    state: started
  ```
  Habilita e inicia el servicio vsftpd.
- **Creación del directorio compartido**:
  ```yaml
  - name: Create shared directory for FTP
  file:
    path: /var/ftp/pub
    state: directory
    mode: '0755'
    owner: ftp
    group: ftp
  ```
  Crea un directorio público en /var/ftp/pub con permisos 0755 y propiedad del usuario ftp.
- **Configuración de vsftpd**:
  ```yaml
  - name: Configure vsftpd for anonymous connections
  lineinfile:
    path: /etc/vsftpd.conf
    regexp: '^#anonymous_enable=YES'
    line: 'anonymous_enable=YES'
  ```
  Habilita el acceso anónimo en el archivo de configuración /etc/vsftpd.conf.
- **Deshabilitación de acceso de usuarios locales**:
  ```yaml
  - name: Disable local users access in vsftpd
  lineinfile:
    path: /etc/vsftpd.conf
    regexp: '^#local_enable=YES'
    line: 'local_enable=NO'
  ```
  Deshabilita el acceso para usuarios locales.
- **Restricciones de permisos para usuarios anónimos**:
  ```yaml
  - name: Disable write permissions for anonymous users
  lineinfile:
    path: /etc/vsftpd.conf
    regexp: '^#anon_upload_enable=YES'
    line: 'anon_upload_enable=NO'
  ```
  Deshabilita la capacidad de subir archivos para usuarios anónimos.
- **Configuración de tiempo de espera**:
  ```yaml
  - name: Set data connection timeout to 30 seconds
  lineinfile:
    path: /etc/vsftpd.conf
    regexp: '^#data_connection_timeout=120'
    line: 'data_connection_timeout=30'
  ```
  Establece un tiempo de espera de 30 segundos para las conexiones inactivas.
- **Limitación de velocidad de transferencia**:
  ```yaml
  - name: Set max transfer rate to 5KB/s for anonymous users
  lineinfile:
    path: /etc/vsftpd.conf
    regexp: '^#anon_max_rate=0'
    line: 'anon_max_rate=5120'
  ```
  Limita la velocidad de transferencia para usuarios anónimos a 5 KB/s.
  - **Configuración del mensaje de bienvenida**:
  ```yaml
  - name: Set FTP banner message
  lineinfile:
    path: /etc/vsftpd.conf
    regexp: '^#ftpd_banner='
    line: 'ftpd_banner=Welcome to SRI FTP anonymous server'
  ```
  Establece un mensaje de bienvenida para los usuarios que se conectan al servidor FTP.
  - **Creación de un archivo de arte ASCII**:
  ```yaml
  - name: Create ASCII art file
  copy:
    content: --WELCOME--
    dest: /var/ftp/pub/welcome.txt
    mode: '0644'
  ```
  Crea un archivo de bienvenida en el directorio público.
    - **Reinicio del servicio**:
  ```yaml
  - name: Restart vsftpd service
  systemd:
    name: vsftpd
    state: restarted
  ```
  Reinicia el servicio vsftpd para aplicar las configuraciones.

  ## Pruebas de Configuración

  - **Pruebas de conexión FTP**:
  ```yaml
  - name: Test passive mode FTP connection
  command: "ftp -p 192.168.56.11"
  register: passive_mode_test
  ```
  Prueba la conexión FTP en modo pasivo.
  - **Verificación de permisos**:
  ```yaml
  - name: Verify directory permissions are read-only for anonymous users
  command: "ls -ld /var/ftp/pub"
  register: dir_permissions
  ```
  Verifica que los permisos del directorio público sean de solo lectura.
  - **Verificación de velocidad de transferencia**:
  ```yaml
  - name: Verify transfer speeds
  command: "ftp 192.168.56.11 -n -v"
  register: transfer_speeds
  ```
  Verifica que la velocidad de transferencia esté limitada a 5 KB/s.
  - **Verificación de tiempo de espera**:
  ```yaml
  - name: Verify timeout occurs after 30 seconds of inactivity
  command: "ftp 192.168.56.11"
  register: timeout_test
  ```
  Asegura que el servidor cierre la conexión después de 30 segundos de inactividad.
