run:
	@./cluster_init.sh
stop:
	@k3d cluster delete iot-phase3

display_pass:
	@echo -n "\e[32mdefault generated admin password is: \e[31m"
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
