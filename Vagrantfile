# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative './vagrant/shared.rb'

Vagrant.configure("2") do |config|
  create_vm(
    config,
    id: 1,
    prefix: "origin",
    extra_disks: 3,
    extra_disks_size: 40
  )
end
