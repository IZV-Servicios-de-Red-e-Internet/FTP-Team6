Vagrant.configure("2") do |config|
  config.vm.box = "debian/bullseye64"

  # DNS Server
  config.vm.define "dns_server" do |dns|
    dns.vm.hostname = "dns.sri.ies"
    dns.vm.network "private_network", ip: "192.168.56.10"
  end

  # FTP Anonymous Server
  config.vm.define "ftp_anonymous" do |ftp_anon|
    ftp_anon.vm.hostname = "ftp-anonymous"
    ftp_anon.vm.network "private_network", ip: "192.168.56.11"
  end

  # FTP Local User Server
  config.vm.define "ftp_local" do |ftp_local|
    ftp_local.vm.hostname = "ftp-local"
    ftp_local.vm.network "private_network", ip: "192.168.56.12"
  end

  # Test Client
  config.vm.define "client" do |client|
    client.vm.hostname = "test-client"
    client.vm.network "private_network", ip: "192.168.56.13"
  end
end
