# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative './vagrant/shared.rb'

Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?('vagrant-registration') && ENV.has_key?('RHEL_USER')
    config.registration.username = ENV['RHEL_USER']
    config.registration.password = ENV['RHEL_PASS']
  end

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
end
