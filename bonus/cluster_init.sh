#!/bin/bash
# can be re-run safely: every step skips what already exists
set -e

APP_SOURCE_REPO="https://github.com/ndelh/iotp3"
GITLAB_LOCAL="localhost:8082"
GITLAB_PROJECT="root/iot-app"
GITLAB_INCLUSTER_URL="http://gitlab.gitlab.svc.cluster.local/${GITLAB_PROJECT}.git"

#create cluster (only if not already there)
if ! k3d cluster list iot-bonus >/dev/null 2>&1; then
	k3d cluster create --config k3d-config.yaml
fi
#create name spaces
for ns in argocd dev gitlab; do
	kubectl create namespace "$ns" --dry-run=client -o yaml | kubectl apply -f -
done

#deploy argocd (server side is needed to avoid error because argo cd config is too heavy to be computed localy)
kubectl apply --server-side -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f argocd-nodeport.yaml

# gitlab: random root password stored in a secret (kept if it already exists), then deploy
if ! kubectl -n gitlab get secret gitlab-root-password >/dev/null 2>&1; then
	kubectl -n gitlab create secret generic gitlab-root-password \
		--from-literal=password="$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 24)"
fi
GITLAB_PASS=$(kubectl -n gitlab get secret gitlab-root-password -o jsonpath='{.data.password}' | base64 -d)
GITLAB_AUTH_URL="http://root:${GITLAB_PASS}@${GITLAB_LOCAL}/${GITLAB_PROJECT}.git"
kubectl apply -f gitlab.yaml

echo -e "\e[33mwaiting for gitlab to be ready (can take 5+ minutes)...\e[0m"
kubectl -n gitlab rollout status deployment/gitlab --timeout=20m
until curl -sf -o /dev/null "http://${GITLAB_LOCAL}/users/sign_in"; do sleep 5; done

# push the app manifests into the local gitlab (push-to-create makes the project)
# skipped if the project already has commits, to never overwrite changes made in gitlab
# (a failed first push can leave an existing but empty project: that one still gets pushed)
if [ -n "$(git ls-remote --heads "$GITLAB_AUTH_URL" 2>/dev/null)" ]; then
	echo "gitlab project ${GITLAB_PROJECT} already has commits, skipping push"
else
	TMP=$(mktemp -d)
	git clone -q "$APP_SOURCE_REPO" "$TMP/app"
	# gitlab answers 502 for a while after its web page is up: retry
	for i in $(seq 1 20); do
		if git -C "$TMP/app" push -q "$GITLAB_AUTH_URL" HEAD:main; then
			break
		fi
		[ "$i" = 20 ] && { echo -e "\e[31mpush to gitlab failed\e[0m"; rm -rf "$TMP"; exit 1; }
		echo -e "\e[33mgitlab not ready yet, retrying push in 15s ($i/20)\e[0m"
		sleep 15
	done
	rm -rf "$TMP"
fi

# give argocd the credentials of the (private) gitlab repo
kubectl -n argocd create secret generic gitlab-repo \
	--from-literal=type=git \
	--from-literal=url="$GITLAB_INCLUSTER_URL" \
	--from-literal=username=root \
	--from-literal=password="$GITLAB_PASS" \
	--dry-run=client -o yaml | kubectl apply -f -
kubectl -n argocd label secret gitlab-repo argocd.argoproj.io/secret-type=repository --overwrite

kubectl wait --for condition=established --timeout=120s crd/applications.argoproj.io
kubectl apply -f application.yaml

echo -e "\e[32mdone: argocd http://localhost:8080 | gitlab http://${GITLAB_LOCAL} (root) | app http://localhost:8081\e[0m"
