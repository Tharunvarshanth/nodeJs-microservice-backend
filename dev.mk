
redeploy-orders-service:
	docker rmi orders-service  delete-orders-service  minikube image rm $(ORDERS_SERVICE_IMAGE_NAME)  make build-orders-service-image  minikube image load $(ORDERS_SERVICE_IMAGE_NAME) --overwrite=true make deploy-orders-service
#

redeploy-customers-service:
	docker rmi customers-service  delete-customers-service  minikube image rm $(CUSTOMERS_SERVICE_IMAGE_NAME)  make build-customers-service-image
#minikube image load $(CUSTOMERS_SERVICE_IMAGE_NAME) --overwrite=true make deploy-customers-service