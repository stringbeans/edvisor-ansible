Configuration variables
============================

Configuration variables are stored in group_vars. For specific stage under stage name like staging/production.
Settings variables are stored in stage_name/settings.yml, where stage_name is staging or production.

Encrypted variables are stored in stage_name/encrypted/file_name.yml. Only datasource variables are stored here like
db username, hosts, passwords, certificates, api keys etc..
Naming for those variables should be like vault_edvisor_var_name. With this we know from templates that this variable
is encrypted with ansible-vault.

Edit encrypted files:

	ansible-vault edit /path/to/file
	
Change password for encrypted files:

	ansible-vault rekey /path/to/file

or for more files:

	ansible-vault rekey /path/to/file /path/to/file2
	
	
Structure
============================

Ansible:

Ansible is used for instance creation/configuration and initial deployment on AWS.

- group_vars: here are stored configuration variables
- hosts: is for host configuration, for configuration of instance/deployment with capistrano the hosts are get from aws
- plugins: here is ansible plugin ec2 file for geting amazon instances
- roles: here are custom roles like common, deploy, pm2 and staging roles like staging/production

deployment templates 

	- config.json
	- datasources.json
	
are stored in roles/deploy/templates.

Capistrano:

Capistrano is used for project deployments to staging/production environments.

There is Capfile.rb and config folder files which belongs to capistrano.

Deploy tasks are stored in config/deploy.rb
Stages for capistrano are stored in config/deploy folder and named like staging.rb / capistrano.rb
Capistrano get instances ids from AWS. It used cap-ec2 capistrano package.

Install Roles
============================
Please take a look at: https://galaxy.ansible.com

The required roles could be install with:
	
		ansible-galaxy install -r requirements.yml
		
When adding additional roles you need to force installation, because roles allready exists:

		sudo ansible-galaxy install --force -r requirements.yml

	
Creation of EC2 Instance
============================

To create an EC2 instance, run the following:

    ansible-playbook -i hosts/staging create-ec2-instance.yml --limit staging --extra-vars "env=staging" -vv --ask-vault-pass
    
It asks for vault password. Enter what is the password and it should continue with instance creation. The
example uses staging for host creation.

It also deploys last release so its needed to check agent forwarding and add key identity per instructions under Deploying project.

Configure EC2 Instance
============================

To configure an EC2 instance, run the following:

		ansible-playbook configure-instance.yml -i plugins/inventory/ec2.py --extra-vars "role=staging env=staging hosts=tag_Name_staging" --ask-vault-pass
		
		
Deploying project
============================

Set environment variables:

	export AWS_ACCESS_KEY_ID = "your aws access key id"
	export AWS_SECRET_ACCESS_KEY = "your aws secret access key"

Install capistrano ( Currently it works with version 3.2.1 )

	gem install capistrano --version=3.2.1
	
Install Cap-EC2

	gem install cap-ec2
	
Install Capistrano NPM

	gem install capistrano-npm
	
Install Capistrano Deploy Tags

	gem install capistrano-deploytags

Check agent forwarding:
		
		ssh-agent

		eval "$(keychain -q --eval --agents ssh)"
		
add key identity:
	
		ssh-add /path/to/key
		
To check, if its working:

		cap staging deploy:check

To deploy the project, run the following:

		cap staging deploy
		
To deploy to more regions change seting in config/ec2.yml, you could add more regions you want to deploy to:

	regions:
   - 'eu-west-1'
		
For more information on deployment with Capistrano take a look at http://capistranorb.com/documentation
