DEFAULT_VM_BOX = ENV['DEFAULT_VM_BOX'] || 'centos/7'

def create_vm(config, options = {})
  prefix = options.fetch(:prefix, "node")
  id = options.fetch(:id, 1)
  extra_disks = options.fetch(:extra_disks, 0)
  extra_disks_size = options.fetch(:extra_disks_size, 0)
  vm_box = options.fetch(:vm_box, DEFAULT_VM_BOX)
  sync = options.fetch(:sync, false)
  vm_name = "%s-%02d" % [prefix, id]

  memory = options.fetch(:memory, 1024)
  cpus = options.fetch(:cpus, 1)

  config.vm.synced_folder '.', '/vagrant', disabled: !sync
  config.vm.define vm_name do |node|
    node.vm.box = vm_box
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

  end
end

def add_extra_disks(vm_name, vb, extra_disks, extra_disks_size)
  dirname = File.dirname(__FILE__)

  vb.customize ['storagectl', :id, '--name', 'CustomSATA', '--add', 'sata', '--portcount', extra_disks]

  for i in 0..(extra_disks-1) do
    disk_path = "#{dirname}/#{vm_name}-disk-#{i}.vdi"
    unless File.exist?(disk_path)
      vb.customize [
        'createhd',
        '--filename', disk_path,
        '--size', extra_disks_size * 1024
      ]
    end

    vb.customize [
      'storageattach', :id,
      '--storagectl', 'CustomSATA',
      '--port', i,
      '--device', 0,
      '--type', 'hdd',
      '--medium', disk_path
    ]
  end
end
