
Install Roles
============================
Please take a look at: https://galaxy.ansible.com

The required roles could be install with:
	
		ansible-galaxy install -r requirements.yml

	
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

Install capistrano:

	gem install capistrano

Check agent forwarding:
		
		ssh-agent

		eval "$(keychain -q --eval --agents ssh)"
		
add key identity:
	
		ssh-add /path/to/key
		
To check, if its working:

		cap staging deploy:check

To deploy the project, run the following:

		cap staging deploy
		











