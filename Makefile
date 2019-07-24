IMG_NAME ?= opsani/servo-statestore-emr
IMG_TAG ?= latest

container:
	docker build . -t $(IMG_NAME):$(IMG_TAG) --network host

push:
	docker push $(IMG_NAME):$(IMG_TAG)
