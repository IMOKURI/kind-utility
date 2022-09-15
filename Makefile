.PHONY: help
.DEFAULT_GOAL := help

up: ## Create a Kind cluster
	kind create cluster --config conf/kind-config.yaml

down: ## Delete a Kind cluster
	kind delete cluster

metal: ## Install MetalLB
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.5/config/manifests/metallb-native.yaml
	sleep 10
	kubectl apply -f conf/metallb-config.yaml

nginx: ## Deploy sample nginx application
	kubectl get namespace my-nginx || kubectl create namespace my-nginx
	kubectl apply -f conf/nginx-app.yaml -n my-nginx

del-nginx: ## Delete sample nginx application
	kubectl delete -f conf/nginx-app.yaml -n my-nginx
	(kubectl get namespace my-nginx && kubectl delete namespace my-nginx) || :

help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[38;2;98;209;150m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
