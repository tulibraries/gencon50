#Defaults
include .env
export #exports the .env variables

#Set DOCKER_IMAGE_VERSION in the .env file OR by passing in
VERSION ?= $(DOCKER_IMAGE_VERSION)
IMAGE ?= tulibraries/$(PROJECT_NAME)
SOLR_IMAGE ?= tulibraries/tul-solr
CLEAR_CACHES ?= no
RAILS_MASTER_KEY = $(shell cat config/master.key)
GENCON50_DB_HOST ?= host.docker.internal
GENCON50_DB_NAME ?= gencon50
GENCON50_DB_USER ?= root
GENCON50_DB_PASSWORD ?= password
GENCON50_DB_ROOT_PASSWORD ?= password
SOLR_VERSION ?= 8.3.0
SOLR_PORT ?= 8973
SOLR_HOST ?= host.docker.internal
SOLR_CORE ?= gencon50
SOLR_URL ?= http://$(SOLR_HOST):$(SOLR_PORT)/solr/$(SOLR_CORE)
DOCKER_NETWORK ?= gc50

CI ?= false

DEV_BUNDLE_PATH ?= vendor/bundle
CWD = $(shell pwd)
DEFAULT_RUN_ARGS ?= -e "EXECJS_RUNTIME=Disabled" \
    -e "K8=yes" \
    -e "GENCON50_DB_HOST=$(GENCON50_DB_HOST)" \
    -e "GENCON50_DB_NAME=$(GENCON50_DB_NAME)" \
    -e "GENCON50_DB_USER=$(GENCON50_DB_USER)" \
    -e "GENCON50_DB_PASSWORD=$(GENCON50_DB_PASSWORD)" \
    -e "GENCON50_DB_ROOT_PASSWORD=$(GENCON50_DB_ROOT_PASSWORD)" \
    -e "RAILS_ENV=production" \
    -e "RAILS_MASTER_KEY=$(RAILS_MASTER_KEY)" \
    -e "RAILS_SERVE_STATIC_FILES=yes" \
    -e "SOLR_URL=$(SOLR_URL)" \
    --rm -it

show-env:
	@echo "SOLR_HOST: $(SOLR_HOST)"
	@echo "SOLR_PORT: $(SOLR_PORT)"
	@echo "SOLR_CORE: $(SOLR_CORE)"
	@echo "SOLR_URL: $(SOLR_URL)"
	@echo "DOCKER_NETWORK: $(DOCKER_NETWORK)"
	@echo "DB_HOST: $(GENCON50_DB_HOST)"
	@echo "RAILS_MASTER_KEY: $(RAILS_MASTER_KEY)"
	@echo "BUNDLE_PATH: $(DEV_BUNDLE_PATH)"

build:
	@docker build --build-arg RAILS_MASTER_KEY=$(RAILS_MASTER_KEY) \
		--tag $(IMAGE):$(VERSION) \
		--tag $(IMAGE):latest \
		--file .docker/app/Dockerfile \
		--no-cache .

up: start-network run-solr run-db run-app

run-app:
	@docker run --name=$(PROJECT_NAME) -d -p 127.0.0.1:3000:3000/tcp \
		$(DEFAULT_RUN_ARGS) \
		$(IMAGE):$(VERSION)
	@docker network connect $(DOCKER_NETWORK) $(PROJECT_NAME)

run-shell:
	@docker run --name=$(PROJECT_NAME) -it -p 127.0.0.1:3000:3000/tcp \
		$(DEFAULT_RUN_ARGS) \
		$(IMAGE):$(VERSION) \
		bash -l
	@docker network connect $(DOCKER_NETWORK) $(PROJECT_NAME)

run-db:
	@docker run --name=$(PROJECT_NAME)-db -d -p 3306:3306 \
		-e MARIADB_ROOT_PASSWORD=$(GENCON50_DB_ROOT_PASSWORD) \
    -e MARIADB_DATABASE=$(GENCON50_DB_NAME) \
    -e MARIADB_USER=$(GENCON50_DB_USER) \
    -e MARIADB_PASSWORD=$(GENCON50_DB_PASSWORD) \
		--mount type=bind,source=$(PWD)/data/db,target=/lib/mysql \
	  bitnami/mariadb:latest
	@docker network connect $(DOCKER_NETWORK) $(PROJECT_NAME)-db
	
run-solr:
	@docker run --name $(PROJECT_NAME)-solr -d -p $(SOLR_PORT):8983 \
		-v $(PWD)/solr:/$(PROJECT_NAME) \
		solr:$(SOLR_VERSION) \
		solr-precreate $(PROJECT_NAME) /$(PROJECT_NAME)
	@docker network connect $(DOCKER_NETWORK) $(PROJECT_NAME)-solr

run-solr-shell:
	@docker run --name=$(PROJECT_NAME)-solr -p $(SOLR_PORT):8983 \
		-v $(PWD)/solrdata:/var/solr \
		-v $(PWD)/solr/conf:/$(PROJECT_NAME) \
		solr:$(SOLR_VERSION) bash -l
	@docker network connect $(DOCKER_NETWORK) $(PROJECT_NAME)-solr

start-network:
	-docker network create $(DOCKER_NETWORK)

shell-app:
	@docker exec -u root -it $(PROJECT_NAME) bash -l

shell-db:
	@docker exec -u root -it $(PROJECT_NAME)-db bash -l

shell-solr:
	@docker exec -u root -it $(PROJECT_NAME)-solr bash -l

stop: stop-app stop-solr stop-db

stop-app:
	-docker stop $(PROJECT_NAME)

stop-db:
	-docker stop $(PROJECT_NAME)-db 

stop-solr:
	-docker stop $(PROJECT_NAME)-solr

rm-solr: stop-solr
	-docker rm $(PROJECT_NAME)-solr

rm-db:
	-docker rm $(PROJECT_NAME)-db

rm-network:
	-docker network rm $(DOCKER_NETWORK)

rm-all: stop-app rm-solr rm-db rm-network

reload: stop-app run-app

repl: build-app reload

lint:
	@if [ $(CI) == false ]; \
		then \
			hadolint .docker/app/Dockerfile; \
		fi

scan:
	@if [ $(CLEAR_CACHES) == yes ]; \
		then \
			trivy $(IMAGE):$(VERSION); \
		fi
	@if [ $(CI) == false ]; \
		then \
			trivy image $(IMAGE):$(VERSION); \
		fi

zip-solr:
	zip -r ~/solrconfig.zip . -x ".git*" \
		Gemfile Gemfile.lock "spec/*" "vendor/*" \
		Makefile ".circle*" "bin/*" LICENSE "README*" \
		docker-compose.yml

build-dev:
	@docker build --build-arg RAILS_MASTER_KEY=$(RAILS_MASTER_KEY) \
		--build-arg RAILS_ENV=development \
		--tag $(IMAGE):$(VERSION)-dev \
		--tag $(IMAGE):dev \
		--file .docker/app/Dockerfile.dev \
		--no-cache .

run-dev:
	@docker run --name=$(PROJECT_NAME)-dev -d \
		-p 127.0.0.1:3000:3000/tcp \
    $(DEFAULT_RUN_ARGS) \
    -e "BUNDLE_PATH=$(DEV_BUNDLE_PATH)" \
    -e "RAILS_ENV=development" \
    --mount type=bind,source=$(CWD),target=/app \
    $(IMAGE):dev sleep infinity
	@docker network connect $(DOCKER_NETWORK) $(PROJECT_NAME)-dev

run-test:
	@docker run --name=$(PROJECT_NAME)-dev -d \
		-p 127.0.0.1:3000:3000/tcp \
    $(DEFAULT_RUN_ARGS) \
    -e "BUNDLE_PATH=$(DEV_BUNDLE_PATH)" \
    -e "RAILS_ENV=test" \
		-e "SOLR_URL=http://localhost:8090/solr/gencon50-1.0/" \
    --mount type=bind,source=$(CWD),target=/app \
    $(IMAGE):dev sleep infinity
	@docker network connect $(DOCKER_NETWORK) $(PROJECT_NAME)-dev

stop-dev:
	@docker stop $(PROJECT_NAME)-dev

stop-test: stop-dev

shell-dev:
	@docker exec -it $(PROJECT_NAME)-dev bash -l

shell-test: shell-dev

reload-dev: stop-dev run-dev

reload-solr: rm-solr run-solr

build-cci:
	@docker build --build-arg RAILS_MASTER_KEY=$(RAILS_MASTER_KEY) \
		--build-arg RAILS_ENV=development \
		--tag $(IMAGE):$(VERSION)-cci \
		--tag $(IMAGE):cci \
		--file .docker/app/Dockerfile.cci \
		--no-cache .
