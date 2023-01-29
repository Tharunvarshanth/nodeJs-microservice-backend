
CLUSTER_NAME=$(K8NS)
K8S_VERSION=1.22
REGION=ap-south-1
BASE_REPO_NAME=$(PROJECT_NAME)-$(ENVIROMENT)

AWS_ACCOUNT_ID?=$(shell aws sts get-caller-identity --query "Account" --output text)
IMAGE_REGISTRY?=$(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com

ORDERS_SERVICE_REPO_NAME=$(BASE_REPO_NAME)/$(ORDERS_SERVICE_NAME)
ORDERS_SERVICE_IMAGE_REPO_URL=$(IMAGE_REGISTRY)/$(ORDERS_SERVICE_REPO_NAME):$(ORDERS_SERVICE_VERSION)

CUSTOMERS_SERVICE_REPO_NAME=$(BASE_REPO_NAME)/$(CUSTOMERS_SERVICE_NAME)
CUSTOMERS_SERVICE_IMAGE_REPO_URL=$(IMAGE_REGISTRY)/$(CUSTOMERS_SERVICE_REPO_NAME):$(CUSTOMERS_SERVICE_VERSION)

local-machine-kubectl-config:
	aws eks update-kubeconfig --region $(REGION) --name $(CLUSTER_NAME)

push-orders-service-registry-image:
	docker tag $(ORDERS_SERVICE_IMAGE_NAME) $(ORDERS_SERVICE_IMAGE_REPO_URL)
	docker push $(ORDERS_SERVICE_IMAGE_REPO_URL)

push-customers-service-registry-image:
	docker tag $(CUSTOMERS_SERVICE_IMAGE_NAME) $(CUSTOMERS_SERVICE_IMAGE_REPO_URL)
	docker push $(CUSTOMERS_SERVICE_IMAGE_REPO_URL)

push-service-images:	push-orders-service-registry-image push-customers-service-registry-image

delete-cluster:
	eksctl delete cluster --name=$(CLUSTER_NAME) --region=$(REGION)

create-cluster:
	- eksctl create cluster \
	      --name $(CLUSTER_NAME) \
          --version $(K8S_VERSION) \
		  --region $(REGION) \
		  --zones=$(REGION)a,$(REGION)b \
          --nodegroup-name $(CLUSTER_NAME)-node-group \
		  --node-type t2.small \
		  --nodes 1



login-registry:
	aws ecr get-login-password --region $(REGION) | docker login --username AWS --password-stdin $(IMAGE_REGISTRY)


create--aws-registry-repositories:
	- aws ecr create-repository --repository-name $(CUSTOMERS_SERVICE_IMAGE_REPO_NAME) --region $(REGION)
	- aws ecr create-repository --repository-name $(ORDERS_SERVICE_REPO_NAME) --region $(REGION)

delete--aws-registry-repositories:
	- aws ecr delete-repository --force --repository-name $(CUSTOMERS_SERVICE_IMAGE_REPO_NAME) --region $(REGION)
	- aws ecr delete-repository --force --repository-name $(ORDERS_SERVICE_REPO_NAME) --region $(REGION)

start:	create-cluster

remove-cluster: delete-cluster

