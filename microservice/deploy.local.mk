
CLUSTER_CPU=2
CLUSTER_MEMORY=5000

IMAGE_REGISTRY=docker.io/library

IMAGE_LOAD_OVERWRITE=false

CUSTOMERS_SERVICE_REPO_NAME=$(CUSTOMERS_SERVICE_NAME)
ORDERS_SERVICE_REPO_NAME=$(ORDERS_SERVICE_NAME)
KEYCLOAK_SERVICE_REPO_NAME=$(KEYCLOAK_SERVICE_NAME)
MYSQL_REPO_NAME=$(MYSQL_NAME)

minikube-delete-images:
	minikube image rm $(ORDERS_SERVICE_IMAGE_NAME)
	minikube image rm $(CUSTOMERS_SERVICE_IMAGE_NAME)
	minikube image rm $(KEYCLOAK_SERVICE_IMAGE_NAME)
	minikube image rm $(MYSQL_IMAGE_NAME)

minikube-load-images:
	minikube image load $(ORDERS_SERVICE_IMAGE_NAME) --overwrite=$(IMAGE_LOAD_OVERWRITE)
	minikube image load $(CUSTOMERS_SERVICE_IMAGE_NAME) --overwrite=$(IMAGE_LOAD_OVERWRITE)
	minikube image load $(KEYCLOAK_SERVICE_IMAGE_NAME) --overwrite=$(IMAGE_LOAD_OVERWRITE)
	minikube image load $(MYSQL_IMAGE_NAME) --overwrite=$(IMAGE_LOAD_OVERWRITE)


delete-cluster:
	minikube delete

create-cluster:
	minikube start --cpus $(CLUSTER_CPU) --memory $(CLUSTER_MEMORY)

create-tunnel:
	- sudo minikube tunnel
	minikube tunnel


start: create-cluster minikube-load-images deploy-app config-namespace create-tunnel
#minikube-load-images