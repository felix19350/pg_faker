DOCKER_TAG := postgres:dev
POSTGRES_PASSWORD := password

.PHONY: build-container
build-container:
	docker build . -t ${DOCKER_TAG}

.PHONY: run-container
run-container:
	docker run -p 5432:5432 \
		-e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
		-v ./:/usr/share/pg-custom-functions \
		${DOCKER_TAG}
