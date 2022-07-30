include versions.mk
include tools.mk
include enviroment.mk
include services.mk
-include overrides.mk

K8NS=$(PROJECT_NAME)-$(ENVIRONMENT)

build-service-images: build-orders-service-image \
                      build-customers-service-image

build-images:	build-service-images

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

deploy-services: depoly-orders-service deploy-orders-service

delete-services: delete-orders-service delete-orders-service

delete-deployment: kubectl delete -n $(K8NS) -f ./deployment
###

###
deploy-routing-config:
    sed -e 's|~APP_HOST|$(APP_HOST)|g;' config/routing.config.yaml | kubectl apply -n $(K8NS) -f -

deploy-config: deploy-routing-config

delete-config: kubectl delete -n $(K8NS) -f ./config
###