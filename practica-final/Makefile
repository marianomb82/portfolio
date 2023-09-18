VENV 	?= venv
PYTHON 	= $(VENV)/bin/python3
PYTEST 	= $(VENV)/bin/pytest
PIP		= $(VENV)/bin/pip

# Variables used to configure
IMAGE_REGISTRY_DOCKER	?= docker.io
IMAGE_REGISTRY_GHCR		?= ghcr.io
IMAGE_REPO				= zasema
IMAGE_NAME				?= paradigma
VERSION					?= dev

# Variables used to configure docker images registries to build and push
IMAGE_DOCKER		= $(IMAGE_REGISTRY_DOCKER)/$(IMAGE_REPO)/$(IMAGE_NAME):$(VERSION)
IMAGE_DOCKER_LATEST	= $(IMAGE_REGISTRY_DOCKER)/$(IMAGE_REPO)/$(IMAGE_NAME):latest
IMAGE_GHCR			= $(IMAGE_REGISTRY_GHCR)/$(IMAGE_REPO)/$(IMAGE_NAME):$(VERSION)
IMAGE_GHCR_LATEST	= $(IMAGE_REGISTRY_GHCR)/$(IMAGE_REPO)/$(IMAGE_NAME):latest

.PHONY: run
run: venv_activate
	python3 -m venv $(VENV)
	$(PYTHON) src/app.py

.PHONY: unit-test
unit-test: venv_activate
	python3 -m venv $(VENV)
	$(PYTEST)

.PHONY: unit-test-coverage
unit-test-coverage: venv_activate
	python3 -m venv $(VENV)
	$(PYTEST) --cov

.PHONY: venv_activate
venv_activate: requirements.txt
	python3 -m venv $(VENV)
	$(PIP) install -r requirements.txt

.PHONY: docker-build
docker-build: ## Build image
	docker build -t $(IMAGE_NAME) .
	docker tag $(IMAGE_NAME) $(IMAGE_DOCKER) 
	docker tag $(IMAGE_NAME) $(IMAGE_DOCKER_LATEST) 
	docker tag $(IMAGE_NAME) $(IMAGE_GHCR)
	docker tag $(IMAGE_NAME) $(IMAGE_GHCR_LATEST)

.PHONY: publish
publish: docker-build ## Publish image
	docker push $(IMAGE_DOCKER)
	docker push $(IMAGE_DOCKER_LATEST)
	docker push $(IMAGE_GHCR)
	docker push $(IMAGE_GHCR_LATEST)