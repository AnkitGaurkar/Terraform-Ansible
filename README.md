# Terraform-Ansible

## Overview
This project integrates **Terraform** and **Ansible** to automate infrastructure provisioning and configuration management. Terraform is used to provision servers, and Ansible is used for configuring them (Docker, Nginx, etc.).

---

## Prerequisites
Before you begin, ensure the following are installed on your local machine:

- **Terraform** ([Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli))
- **Ansible** ([Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html))
- **AWS CLI** (if using AWS)
- **Git**
- **SSH Keys** configured for Ansible access to servers

---

## Installation

### 1. Update and Install Ansible
```bash
sudo apt-get update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
ansible --version  # Verify installation
2. Configure Ansible Inventory
Create your inventory files in inventories/:

bash
Copy code
mkdir ~/Terraform-Ansible/inventories
cd ~/Terraform-Ansible/inventories
vim dev   # Development servers
vim prd   # Production servers
Example content for prd:

ini
Copy code
[Ankit_Servers]
Server1 ansible_host=IP_ADDRESS_1 ansible_user=ec2-user ansible_ssh_private_key_file=~/keys/ansible-terra-key-ec2.pem
Server2 ansible_host=IP_ADDRESS_2 ansible_user=ec2-user ansible_ssh_private_key_file=~/keys/ansible-terra-key-ec2.pem

[Ankit_Servers:vars]
ansible_python_interpreter=/usr/bin/python3
Note: Replace IP_ADDRESS_1 and IP_ADDRESS_2 with your actual server IPs.

3. Prepare SSH Keys
bash
Copy code
mkdir ~/Terraform-Ansible/keys
cd ~/Terraform-Ansible/keys
# Use your existing key or create a new one
ssh-keygen -t rsa -b 4096 -f ansible-terra-key-ec2.pem
chmod 400 ansible-terra-key-ec2.pem
Ansible Commands
1. Test Server Connectivity
bash
Copy code
ansible Ankit_Servers -i ../inventories/dev -m ping
ansible Ankit_Servers -i ../inventories/prd -m ping
2. Run Commands on Servers
bash
Copy code
ansible Server1 -i ../inventories/dev -a "docker ps"
ansible Server1 -i ../inventories/dev -a "sudo docker ps"
3. Install Docker Using Ansible
Create playbooks/install_docker.yml:

Run the playbook:

bash
Copy code
ansible-playbook -i ../inventories/prd playbooks/install_docker.yml
Verify Docker installation:

bash
Copy code
ansible Server1 -i ../inventories/prd -a "docker --version"
Inventory Management
Use separate inventories for dev and prd environments:

inventories/dev → Development servers

inventories/prd → Production servers

Run a playbook with a specific inventory:

bash
Copy code
ansible-playbook -i ../inventories/prd playbooks/install_docker.yml
Cloning the Repository
bash
Copy code
git clone https://github.com/AnkitGaurkar/terraform-ansible.git
cd terraform-ansible
Conclusion
This setup automates infrastructure provisioning with Terraform and server configuration with Ansible. You can extend it to install additional software, manage users, or configure monitoring.

Maintainer: Ankit Gaurkar
