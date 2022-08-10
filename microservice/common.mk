include versions.mk
include tools.mk
include enviroment.mk
include services.mk
-include overrides.mk

MYSQL_NAME=$(PROJECT_NAME)-mysql
K8NS=$(PROJECT_NAME)-$(ENVIROMENT)
BOOKING_KONG_REPO_NAME=$(PROJECT_NAME)-kong

MYSQL_IMAGE_NAME=$(MYSQL_NAME):$(MYSQL_VERSION)

create-namespace:
	-kubectl create ns $(K8NS)

config-namespace:
	kubectl config set-context --current --namespace=$(K8NS)

build-db-image:
	$(DOCKER_BUILD_CMD) -f deployment/db/Dockerfile deployment/db -t $(MYSQL_IMAGE_NAME)

build-service-images: build-orders-service-image \
                      build-customers-service-image

build-images:	build-db-image build-service-images

clean-services: clean-orders-service \
				clean-customers-service

###
depoly-mysql-db:
	helm repo add bitnami https://charts.bitnami.com/bitnami
#	helm install booking-db bitnami/mysql
#	helm install booking-db -f ./deployment/value-files/values-mysql.yaml bitnami/mysql -n $(K8NS)
	sed -e 's|~REGISTRY|$(IMAGE_REGISTRY)|g;s|~REPOSITORY|$(MYSQL_REPO_NAME)|g;s|~TAG|$(MYSQL_VERSION)|g;' deployment/value-files/values-mysql.yaml | helm install booking-db bitnami/mysql -n $(K8NS) -f -

upgrade-db:
	sed -e 's|~REGISTRY|$(IMAGE_REGISTRY)|g;s|~REPOSITORY|$(MYSQL_REPO_NAME)|g;s|~TAG|$(MYSQL_VERSION)|g;' deployment/value-files/values-mysql.yaml | helm upgrade booking-db bitnami/mysql -n $(K8NS) -f -

delete-db:
	helm delete booking-db

deploy-customers-service:
	sed -e 's|~REGISTRY|$(IMAGE_REGISTRY)|g;s|~REPOSITORY|$(CUSTOMERS_SERVICE_REPO_NAME)|g;s|~TAG|$(CUSTOMERS_SERVICE_VERSION)|g;' deployment/customers-service.deployment.yaml | kubectl apply -n $(K8NS) -f -

delete-customers-service:
	kubectl delete -n $(K8NS) -f deployment/customers-service.deployment.yaml

deploy-orders-service:
	sed -e 's|~REGISTRY|$(IMAGE_REGISTRY)|g;s|~REPOSITORY|$(ORDERS_SERVICE_REPO_NAME)|g;s|~TAG|$(ORDERS_SERVICE_VERSION)|g;' deployment/orders-service.deployment.yaml | kubectl apply -n $(K8NS) -f -

delete-orders-service:
	kubectl delete -n $(K8NS) -f deployment/orders-service.deployment.yaml

deploy-keycloak-service:
	sed -e 's|~REGISTRY|$(IMAGE_REGISTRY)|g;s|~REPOSITORY|$(KEYCLOAK_SERVICE_REPO_NAME)|g;s|~TAG|$(KEYCLOAK_SERVICE_VERSION)|g;' deployment/keycloak.deployment.yaml | kubectl apply -n $(K8NS) -f -

delete-keycloak-service:
	kubectl delete -n  $(K8NS) -f deployment/keycloak.deployment.yaml

deploy-services: deploy-orders-service deploy-customers-service deploy-keycloak-service

delete-services: delete-orders-service delete-customers-service delete-keycloak-service

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

deploy-kong-gateway:
	helm repo add kong https://charts.konghq.com
	sed -e 's|~REGISTRY|$(IMAGE_REGISTRY)|g;s|~REPOSITORY|$(BOOKING_KONG_REPO_NAME)|g;s|~TAG|$(BOOKING_KONG_VERSION)|g;' deployment/value-files/values-kong.yaml | helm install booking-kong-gateway kong/kong -n $(K8NS) -f -

upgrade-kong-gateway:
	deployment/value-files/values-kong.yaml | helm upgrade booking-kong-gateway kong/kong -n $(K8NS) -f -

delete-kong-gateway:
	helm delete booking-kong-gateway

deploy-deployment: deploy-services

delete-deployment:
	kubectl delete -n $(K8NS) -f ./deployment

###
deploy-routing-config:
	sed -e 's|~APP_HOST|$(APP_HOST)|g;' config/routing.config.yaml | kubectl apply -n $(K8NS) -f -

deploy-orders-service-config:
	sed -e 's|~DB_HOST|$(DB_HOST)|g;s|~DB_PORT|$(DB_PORT)|g;s|~DB_USER|$(DB_USER)|g;s|~DB_PASSWORD|$(DB_PASSWORD)|g;' config/orders-service.config.yaml | kubectl apply -n $(K8NS) -f -

deploy-customers-service-config:
	sed -e 's|~DB_HOST|$(DB_HOST)|g;s|~DB_PORT|$(DB_PORT)|g;s|~DB_USER|$(DB_USER)|g;s|~DB_PASSWORD|$(DB_PASSWORD)|g;' config/customers-service.config.yaml | kubectl apply -n $(K8NS) -f -

deploy-db-config:
	sed -e 's|~DB_HOST|$(DB_HOST)|g;s|~DB_PORT|$(DB_PORT)|g;s|~DB_USER|$(DB_USER)|g;s|~DB_PASSWORD|$(DB_PASSWORD)|g;' config/db.config.yaml | kubectl apply -n $(K8NS) -f -

deploy-app-general-config:
	sed -e 's|~FRONTEND_URL|$(FRONTEND_URL)|g;' config/general-app.config.yaml | kubectl apply -n $(K8NS) -f -

deploy-config:	deploy-db-config deploy-app-general-config deploy-routing-config deploy-orders-service-config deploy-customers-service-config

delete-config:
	kubectl delete -n $(K8NS) -f ./config
###



deploy-app: create-namespace deploy-kong-gateway deploy-config depoly-mysql-db deploy-deployment

delete-app:
	kubectl delete ns $(K8NS)
