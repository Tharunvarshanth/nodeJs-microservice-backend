ORDERS_SERVICE_NAME=orders-service
CUSTOMERS_SERVICE_NAME=customers-service


ORDERS_SERVICE_IMAGE_NAME=$(ORDERS_SERVICE_NAME):$(ORDERS_SERVICE_VERSION)
CUSTOMERS_SERVICE_IMAGE_NAME=$(CUSTOMERS_SERVICE_NAME):$(CUSTOMERS_SERVICE_VERSION)


### orders service ###
# docker run --publish 3001:3001 customers-service:0.0.1
clean-orders-service:
	rm -rf services/orders/dist

build-orders-service-image:
	$(DOCKER_BUILD_CMD) -f services/orders/Dockerfile services/orders -t $(ORDERS_SERVICE_IMAGE_NAME)
###

### customer service ###
clean-customers-service:
	rm -rf services/customers/dist

build-customers-service-image:
	$(DOCKER_BUILD_CMD) -f services/customers/Dockerfile services/customers -t $(CUSTOMERS_SERVICE_IMAGE_NAME)
###