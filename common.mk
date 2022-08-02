include versions.mk
include tools.mk
include enviroment.mk
include services.mk
-include overrides.mk

K8NS=$(PROJECT_NAME)-$(ENVIROMENT)
KONG_NAME=$(PROJECT_NAME)-kong

create-namespace:
	-kubectl create ns $(K8NS)

config-namespace:
	kubectl config set-context --current --namespace=$(K8NS)

build-service-images: build-orders-service-image \
                      build-customers-service-image

build-images: build-service-images

clean-services: clean-orders-service \
				clean-customers-service

###
deploy-customers-service:
	sed -e 's|~REGISTRY|$(IMAGE_REGISTRY)|g;s|~REPOSITORY|$(CUSTOMERS_SERVICE_REPO_NAME)|g;s|~TAG|$(CUSTOMERS_SERVICE_VERSION)|g;' deployment/customers-service.deployment.yaml | kubectl apply -n $(K8NS) -f -

delete-customers-service:
	kubectl delete -n $(K8NS) -f deployment/customers-service.deployment.yaml

deploy-orders-service:
	sed -e 's|~REGISTRY|$(IMAGE_REGISTRY)|g;s|~REPOSITORY|$(ORDERS_SERVICE_REPO_NAME)|g;s|~TAG|$(ORDERS_SERVICE_VERSION)|g;' deployment/orders-service.deployment.yaml | kubectl apply -n $(K8NS) -f -

delete-orders-service:
	kubectl delete -n $(K8NS) -f deployment/orders-service.deployment.yaml

deploy-services: deploy-orders-service deploy-customers-service

delete-services: delete-orders-service delete-customers-service

###
deploy-gateway:
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
#	helm repo update
#	helm install nginx-ingress -f deployment/value-files/values-ingress-nginx.yaml ingress-nginx/ingress-nginx -n $(K8NS)
	helm install nginx-ingress ingress-nginx/ingress-nginx -n $(K8NS)
	kubectl delete -A ValidatingWebhookConfiguration  nginx-ingress-ingress-nginx-admission

upgrade-gateway:
	helm upgrade booking-gateway ingress-nginx/ingress-nginx -n $(K8NS)

remove-ingres-admin-webhook:
	kubectl delete -A ValidatingWebhookConfiguration  nginx-ingress-ingress-nginx-admission

delete-gateway:
	helm uninstall nginx-ingress

deploy-gateway-kong:
	helm repo add kong https://charts.konghq.com
	sed -e 's|~REGISTRY|$(IMAGE_REGISTRY)|g;s|~REPOSITORY|$(KONG_REPO_NAME)|g;s|~TAG|$(KONG_VERSION)|g;' deployment/value-files/kong-values.config.yaml | helm install booking-gateway kong/kong -n $(K8NS) -f -

upgrade-gateway-kong:
	sed -e 's|~REGISTRY|$(IMAGE_REGISTRY)|g;s|~REPOSITORY|$(KONG_REPO_NAME)|g;s|~TAG|$(KONG_VERSION)|g;' deployment/value-files/kong-values.config.yaml | helm upgrade booking-gateway kong/kong -n $(K8NS) -f -

delete-gateway-kong:
	helm uninstall -n $(K8NS) booking-gateway

deploy-deployment: deploy-services

delete-deployment:
	kubectl delete -n $(K8NS) -f ./deployment

###
deploy-routing-config:
	sed -e 's|~APP_HOST|$(APP_HOST)|g;s|~NAME_SPACE|$(K8NS)|g;' config/routing.config.yaml | kubectl apply -n $(K8NS) -f -

deploy-config: deploy-routing-config

delete-config:
	kubectl delete -n $(K8NS) -f ./config
###



deploy-app: create-namespace deploy-gateway deploy-config deploy-deployment

delete-app:
	kubectl delete ns $(K8NS)
