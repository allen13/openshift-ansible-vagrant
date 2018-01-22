## openshift-ansible-vagrant

Deploy and maintain an openshift-ansible based cluster. Use vagrant and virtualbox for easy testing and development of the cluster.


## Playbook Style/Design Guide

 - **bin/{environment}**
	 - all  interactions with the cluster should be kept here
 - **inventories/{environment}**
	 - group_vars
		 - group.yml
			 - all configs for the cluster should be found here in their respective group file
	 - host_vars
		 - host.yml
			 - any config values that are specific to a certain host. Putting configuration here indicates a snowflake server problem. Think twice before putting configs here.
	 - cluster_inventory_file
		 - Inventory files should only contain basic connection/ip information and groups.
- **playbooks**
	- openshift-ansible
		- this folder should be a git checkout or a symlink to the openshift-ansible project. It has been ignored so that nothing here gets commited and can be unique to each environment.
	 -  playbook.yml
		 - All playbook files can be stored in this directory. If a need arises to organize the playbooks they can be placed in sub-folders.
	- roles
		- myrole
			- standard location for ansible roles
- **vagrant**
	- place to store vagrant related files
- **Vagrantfile**
	- basic vagrant config
