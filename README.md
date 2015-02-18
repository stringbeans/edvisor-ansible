
Install Roles
============================
Please take a look at: https://galaxy.ansible.com
	
Users: ansible-galaxy install mivok0.users
	Github: https://github.com/mivok/ansible-users
NVM+NodeJs: ansible-galaxy install leonidas.nvm
	Github: https://github.com/leonidas/ansible-nvm
	

Creation of EC2 Instance
============================

To create an EC2 instance, run the following:

    ansible-playbook -i hosts/staging create-ec2-instance.yml --limit staging -vv --ask-vault-pass
    
It asks for vault password. Enter what is the password and it should continue with instance creation. The
example uses staging for host creation.

Configure EC2 Instance
============================

To configure an EC2 instance, run the following:

		ansible-playbook configure-instance.yml -i plugins/inventory/ec2.py --extra-vars "role=staging env=staging user=admin hosts=tag_Name_staging" --ask-vault-pass











