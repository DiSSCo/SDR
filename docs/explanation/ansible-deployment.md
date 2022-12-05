# Ansible for the SDR #

Ansible is a tool for automating system administration tasks, primarily on remote machines.

## Ansible overview ##

Ansible scripts are known as playbooks and detail "tasks": command line instructions or groups of processes executed as if an administrator was connecting to the remote machine via SSH and running the commands. Ansible "roles" are provided by the community and automate entire processes and platforms.

The approach Ansible takes is very powerful, falling short of full containerisation (e.g. Docker) and retaining the ability to set up a platform in the traditional manner, but far more formalised, repeatable and sharable than simply employing a knowledgeable human.

## Ansible for Galaxy ##

The Galaxy collaboration have developed a set of [Ansible playbooks](https://github.com/galaxyproject/ansible-galaxy) which can deploy a standard instance of Galaxy with [relative ease](https://training.galaxyproject.org/training-material/topics/admin/tutorials/ansible/tutorial.html).

The deployment process adopted for the SDR is heavily based on this approach, only extended to include SDR specific configuration and tools.

## Ansible for the SDR ##

The Ansible playbook developed for extending the deployment of Galaxy to include 
