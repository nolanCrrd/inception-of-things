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
rerun:
	@rm -rf .vagrant ; make
