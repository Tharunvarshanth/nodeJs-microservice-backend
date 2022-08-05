
redeploy-orders-service:
	- docker rmi $(ORDERS_SERVICE_IMAGE_NAME)
	  delete-orders-service \
	- minikube image rm $(ORDERS_SERVICE_IMAGE_NAME)
	  build-orders-service-image \
	- minikube image load $(ORDERS_SERVICE_IMAGE_NAME)
	  deploy-orders-service
#

redeploy-customers-service:
	docker rmi $(CUSTOMERS_SERVICE_IMAGE_NAME) \
	delete-customers-service \
	minikube image rm $(CUSTOMERS_SERVICE_IMAGE_NAME) \
	build-customers-service-image \
	minikube image load $(CUSTOMERS_SERVICE_IMAGE_NAME) \
	deploy-customers-service
#minikube image load $(CUSTOMERS_SERVICE_IMAGE_NAME) --overwrite=true make deploy-customers-service