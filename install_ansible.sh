#!/bin/bash

echo "Actualizando los repositorios..."
sudo apt update -y

echo "Instalando Ansible..."
sudo apt install -y ansible

echo "Verificando la instalación de Ansible..."
ansible --version

if [ $? -eq 0 ]; then
    echo "Ansible se instaló correctamente. Ahora se ejecutará Vagrant automáticamente."
else
    echo "Hubo un error al instalar Ansible. Revisa los registros para más detalles."
    exit 1
fi

