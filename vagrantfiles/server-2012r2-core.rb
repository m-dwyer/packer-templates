Vagrant.configure(2) do |config|
	config.vm.define "server-2012r2-core"
	config.vm.box = "server-2012r2-core"
	config.vm.guest = :windows
	config.vm.communicator = :winrm
	config.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp"
	config.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm"

	config.vm.provision "shell",
	  inline: "New-PSDrive -Name \"V\" -PSProvider FileSystem -Root \"\\\\VBOXSVR\\vagrant\" -Persist"

end
