VM_BOX = 'centos/7'

def create_vm(config, options = {})
  prefix = options.fetch(:prefix, "node")
  id = options.fetch(:id, 1)
  extra_disks = options.fetch(:extra_disks, 0)
  extra_disks_size = options.fetch(:extra_disks_size, 0)
  vm_name = "%s-%02d" % [prefix, id]

  memory = options.fetch(:memory, 1024)
  cpus = options.fetch(:cpus, 1)

  config.vm.define vm_name do |node|
    node.vm.box = VM_BOX
    node.vm.hostname = vm_name

    private_ip = "192.0.2.10#{id}"
    node.vm.network :private_network, ip: private_ip, netmask: "255.255.255.128"

    public_ip = "192.0.2.20#{id}"
    node.vm.network :private_network, ip: public_ip, netmask: "255.255.255.128"

    node.vm.provider :virtualbox do |vb|
      vb.memory = memory
      vb.cpus = cpus
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
      vb.check_guest_additions = false
      vb.functional_vboxsf = false
      add_extra_disks(vm_name, vb, extra_disks, extra_disks_size) if extra_disks > 0
    end

    node.vm.provision :shell, inline: "yum install ansible -y"
  end
end

def add_extra_disks(vm_name, vb, extra_disks, extra_disks_size)
  dirname = File.dirname(__FILE__)

  # Disk limit
  if extra_disks > 3
    extra_disks = 3
  end

  # Add extra disks
  for i in 1..extra_disks do
    # Create disk
    disk_path = "#{dirname}/#{vm_name}-disk-#{i}.vdi"
    unless File.exist?(disk_path)
      vb.customize [
        'createhd',
        '--filename', disk_path,
        '--size', extra_disks_size * 1024
      ]
    end

    # which port and master or slave on ide
    if i < 2
      port = 0
      device = i
    else
      port = 1
      device = i - 2
    end

    # Attach disk
    vb.customize [
      'storageattach', :id,
      '--storagectl', 'IDE',
      '--port', port,
      '--device', device,
      '--type', 'hdd',
      '--medium', disk_path
    ]
  end
end
