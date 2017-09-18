# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  
  config.vm.hostname = "combine-vm"

  config.vm.box = "bento/ubuntu-16.04"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 6072
    vb.cpus = 2
    config.vm.network "private_network", ip: "192.168.45.10"
  end

  # sets shared dir that is passed to bootstrap
  shared_dir = "/vagrant"  

  config.vm.provision "shell", path: "./install_scripts/bootstrap.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/apache.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/java.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/elasticsearch.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/spark.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/ingestion3.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/livy.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/hadoop.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/cyavro.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/supervisor.sh", args: shared_dir

end
