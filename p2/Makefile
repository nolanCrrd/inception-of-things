run: checkenv
	@vagrant up
checkenv: 
	@if [ ! -f .env ]; then \
		echo "env file is missing"; \
		exit 1; \
	fi

down:
	@vagrant halt

destroy: 
	@vagrant destroy -f
	@echo "\e[32mpart 2 successfully destroyed\e[0m"
rerun:
	@rm -rf .vagrant ; make
