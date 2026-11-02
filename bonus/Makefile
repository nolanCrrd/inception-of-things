run:
	@./cluster_init.sh
stop:
	@k3d cluster delete iot-bonus

display_pass:
	@printf "\033[32margocd  (admin): \033[31m%s\033[0m\n" "$$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)"
	@printf "\033[32mgitlab  (root) : \033[31m%s\033[0m\n" "$$(kubectl -n gitlab get secret gitlab-root-password -o jsonpath='{.data.password}' | base64 -d)"
