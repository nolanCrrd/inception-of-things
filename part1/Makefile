#Machine user
USER=ncorrear
#Domain name
SERVER_DOMAIN=part1_ndelhotaS
AGENT_DOMAIN=part1_ndelhotaSW
#cmd

run:
	@if [ ! -f .env ]; then \
		make gen_env; \
	else \
		echo ".env successfully found"; \
	fi; \
	echo "now launching" ;\
	gnome-terminal -- bash -c btop; \
	vagrant up

destroy:
	@vagrant destroy --force

gen_env:
	@echo ".env is missing, generating a default one"; \
	echo  "K3S_SERVER_IP=192.168.56.110" > .env ; \
	echo "K3S_AGENT_IP=192.168.56.111" >> .env ; \
	echo "K3S_TOKEN=67ETHODE">> .env ; \
	echo ".env successfully generated"

root_check:
	@if [ $$(whoami) != root ]; then \
		echo "some cmd must be run as root"; \
		exit 1 ;\
	fi ;

list: root_check
	@echo "virsh list --all result:"; \
	virsh list --all;

erase_domain: root_check
	@echo "rming the domain"; \
	virsh destroy $(SERVER_DOMAIN); \
	virsh undefine $(SERVER_DOMAIN); \
	virsh destroy $(AGENT_DOMAIN); \
	virsh undefine $(AGENT_DOMAIN); \
    	vagrant destroy	

restore crash: root_check
	vagrant plugin install vagrant-reload reload ;\
	make erase_domain ; \
	chown -R $(USER):$(USER) .vagrant

help:
	@echo "sudo virsh list --all :list all current domain"; \
	@echo "sudo virsh destroy; virsh undefine : erase domain" 

