Install Ansible
=====================

Installation of Ansible is required. You could find information how to install Ansible
for different platforms on following official website.

	http://docs.ansible.com/intro_installation.html

If you need to install

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

Install Roles using Ansible Galaxy
============================
Please take a look at: https://galaxy.ansible.com

The required roles could be install with:
	
		ansible-galaxy install -r requirements.yml
		
When adding additional roles you need to force installation, because roles allready exists:

		sudo ansible-galaxy install --force -r requirements.yml
		


Create AWS Subnet
============================

To create AWS Subnet you need to go to AWS Console -> VPC -> Subnets-> Create subnet.

Create AWS Security Group
============================

For creation of AWS Security Group you need to go to AWS Console -> EC2 -> Network & Security -> Security Groups
	-> Create Security Group
	
Its good to separate production and staging security group, so you could name it like
edvisor-staging and edvisor-production.

Create AWS Network Interface
============================

Create AWS Network interface go to AWS Console -> EC2 -> Network & Security -> Network Interfaces
	-> Create network interface

	
Creation of EC2 Instance
============================

To create an EC2 instance, run the following:

    ansible-playbook -i hosts/staging create-ec2-instance.yml --limit staging --extra-vars "env=staging" -vv --ask-vault-pass
    
It asks for vault password. Enter what is the password and it should continue with instance creation. The
example uses staging for host creation.

It also deploys last release so its needed to check agent forwarding and add key identity per instructions under Deploying project.

If you would like to change region for instance you could change it via --extra-vars "env=staging region=us-east-1" or in group_vars/settings.yml.

Configure EC2 Instance
============================

To configure an EC2 instance, run the following:

		ansible-playbook configure-instance.yml -i plugins/inventory/ec2.py --extra-vars "role=staging env=staging hosts=tag_Stages_staging" --ask-vault-pass
		
		
Configuration for project deployment
========================================================

Set environment variables:

	export AWS_ACCESS_KEY_ID = "your aws access key id"
	export AWS_SECRET_ACCESS_KEY = "your aws secret access key"

Install bundler:

		gem install bundler
		
Install gems from the Gemfile with:

		bundler install


Check agent forwarding:
		
		ssh-agent

		eval "$(keychain -q --eval --agents ssh)"
		
Add key identity:
	
		ssh-add /path/to/key
		
To check, if its working:

		cap staging deploy:check
		
Deployment
========================================================

Deployment user is stored in group_vars/staging or production/users.yml called deploy. If you need
to add public ssh-key for different developers/deployers you could add there in the ssh-key list.
If there is need of deletion of user you need to remove it and run configure-ec2-instance for specific stage
environment where you want to delete user.

Deploy:

To deploy the project, run the following:

		cap staging deploy
		
To deploy to more regions change seting in config/ec2.yml, you could add more regions you want to deploy to:

	regions:
   - 'eu-west-1'
   
Rollback:

		cap staging deploy:rollback
		
PM2 commands:

Restarting process manager:

		cap staging deploy:restart
		
Pm2 status, get status of processes on all hosts:

		cap staging deploy:status
		
Pm2 lists, it lists running processes on all hosts:

		cap staging deploy:list
		
Pm2 logs, it streams logs files:

		cap staging deploy:logs
		
Pm2 kill, it kills deamon. It should be used with caution on production.

		cap staging deploy:kill
		
Pm2 start. If you kill processes you could again start them with:
		
		cap staging deploy:start
		
For more information on deployment with Capistrano take a look at http://capistranorb.com/documentation


Configure Elastic Load Balancer
========================================================

On Aws:

More information on: http://aws.amazon.com/elasticloadbalancing/getting-started/

Going to AWS console and then choose EC2 -> Load balancers -> Create load balancer.


1. Initial LB config:

- Add load balancer name
- Create LB inside VPC
- Add listener configuration
	- Load balancer protocol ( http or https ). In case of https you need to add certificates.
	- Load balancer port ( 80 or 443 )
	- Instance protocol and instance port. If you run instances in private network, then you could use port 80 with ssl.
	- Choose instances port. Instances are configurd that api listens on port 3000.
	
	
2. Add healthcheck
	- Configure healtcheck. More information you could find on AWS Load Balancer documentation
	
3. Add instances
	- You could add instances to load balancer.
	
	
	
After you created loadbalancer you need to add load balancer DNS name to A Record for domain or subdomain in case of staging.


