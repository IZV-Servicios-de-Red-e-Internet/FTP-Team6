Vagrant.configure("2") do |config|
  config.vm.box = "debian/bullseye64"

  # FTP Local User Server
  config.vm.define "ftp-local" do |ftp_local|
    ftp_local.vm.hostname = "ftp-local"
    ftp_local.vm.network "private_network", ip: "192.168.56.12"
    ftp_local.vm.provision "ansible" do |ansible|
      ansible.playbook = "ftp_local.yml"
    end
  end
end
