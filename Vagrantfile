# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative './vagrant/shared.rb'

Vagrant.configure("2") do |config|
  register_rhel_subscription(config)

  create_vm(
    config,
    id: 1,
    prefix: "ocp",
    cpus: 2,
    memory: 2048,
    extra_disks: 3,
    extra_disks_size: 40
  )

  create_vm(
    config,
    id: 2,
    prefix: "ocp",
    cpus: 2,
    memory: 2048,
    extra_disks: 3,
    extra_disks_size: 40
  )

  create_vm(
    config,
    id: 3,
    prefix: "ocp",
    cpus: 1,
    memory: 1024,
    extra_disks: 3,
    extra_disks_size: 40
  )
end
