.PHONY: all help build run builddocker rundocker kill rm-image rm clean enter logs

all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""   1. make run       - build and run docker container
	@echo ""   2. make build     - build docker container
	@echo ""   3. make clean     - kill and remove docker container
	@echo ""   4. make enter     - execute an interactive bash in docker container
	@echo ""   3. make logs      - follow the logs of docker container

build: NAME TAG builddocker

r: build run logs

# run a plain container
run: BRANCH PORT NAME TAG rm meango.cid rundocker

rundocker:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	$(eval BRANCH := $(shell cat BRANCH))
	$(eval PORT := $(shell cat PORT))
	chmod 777 $(TMP)
	@docker run --name=$(NAME) \
	--cidfile="cid" \
	-e BRANCH=$(BRANCH) \
	-d \
	--link meanshop-meango:meango \
	-p $(PORT):8080 \
	-t $(TAG)

test: PORT NAME TAG rm testdocker

testdocker:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	$(eval PORT := $(shell cat PORT))
	chmod 777 $(TMP)
	@docker run --name=$(NAME) \
	--cidfile="cid" \
	-v $(TMP):/tmp \
	-d \
	-p $(PORT):80 \
	-t $(TAG) bash -l -c 'node -v;npm -v; ruby -v; which sass; /bin/bash'

prod: PORT NAME TAG rm proddocker

proddocker:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	$(eval PORT := $(shell cat PORT))
	chmod 777 $(TMP)
	@docker run --name=$(NAME) \
	--cidfile="cid" \
	-v $(TMP):/tmp \
	-d \
	-p $(PORT):80 \
	-t $(TAG) '/meanshop/prodstart.sh'

builddocker:
	/usr/bin/time -v docker build -t `cat TAG` .

kill:
	-@docker kill `cat cid`
	-@docker kill `cat node.cid`
	-@docker kill `cat prod.cid`
	-@docker kill `cat nginx.cid`
	-@docker kill `cat meango.cid`

rm-image:
	-@docker rm `cat cid`
	-@docker rm `cat node.cid`
	-@docker rm `cat prod.cid`
	-@docker rm `cat nginx.cid`
	-@docker rm `cat meango.cid`
	-@rm cid
	-@rm node.cid
	-@rm prod.cid
	-@rm nginx.cid
	-@rm meango.cid

rm: kill rm-image

clean: rm

enter:
	docker exec -i -t `cat cid` /bin/bash -l

logs:
	@docker logs -f `cat cid`

NAME:
	@while [ -z "$$NAME" ]; do \
		read -r -p "Enter the name you wish to associate with this container [NAME]: " NAME; echo "$$NAME">>NAME; cat NAME; \
	done ;

TAG:
	@while [ -z "$$TAG" ]; do \
		read -r -p "Enter the tag you wish to associate with this container [TAG]: " TAG; echo "$$TAG">>TAG; cat TAG; \
	done ;

BRANCH:
	@while [ -z "$$BRANCH" ]; do \
		read -r -p "Enter the branch you wish to work with e.g. 'master' [BRANCH]: " BRANCH; echo "$$BRANCH">>BRANCH; cat BRANCH; \
	done ;

PORT:
	@while [ -z "$$PORT" ]; do \
		read -r -p "Enter the tag you wish to associate with this container [PORT]: " PORT; echo "$$PORT">>PORT; cat PORT; \
	done ;

compose:
	docker-compose up

up: compose

pull:
	docker pull `cat TAG`

update:
	rm -Rf nginx/client
	rm -Rf node/server
	cp -a client nginx/
	cp -a server node/

node.cid: meango.cid MEANSHOPTMP
	/usr/bin/time -v docker build -t `cat TAG`:node -f node.Dockerfile
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval MEANSHOPTMP := $(shell cat MEANSHOPTMP))
	$(eval TAG := $(shell cat TAG))
	$(eval BRANCH := $(shell cat BRANCH))
	$(eval PORT := $(shell cat PORT))
	chmod 777 $(TMP)
	@docker run --name=$(NAME)-node \
	--cidfile="node.cid" \
	--link meanshop-meango:meango \
	-e BRANCH=$(BRANCH) \
	-p 9000:9000 \
	-d \
	-t $(TAG):node

nodetest: clean node.cid nginx.cid logsnode

nd: nodetest

enternode:
	docker exec -i -t `cat node.cid` /bin/bash -l

logsprod:
	@docker logs -f `cat prod.cid`

logsnode:
	@docker logs -f `cat node.cid`

nginx.cid:
	/usr/bin/time -v docker build -t `cat TAG`:nginx -f nginx.Dockerfile
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	$(eval BRANCH := $(shell cat BRANCH))
	$(eval PORT := $(shell cat PORT))
	chmod 777 $(TMP)
	@docker run --name=$(NAME)-nginx \
	--cidfile="nginx.cid" \
	--link meanshop-node:meanshop-node \
	-v $(TMP):/tmp \
	-e BRANCH=$(BRANCH) \
	-p $(PORT):80 \
	-d \
	-t $(TAG):nginx

enternginx:
	docker exec -i -t `cat nginx.cid` /bin/bash -l

logsnginx:
	@docker logs -f `cat nginx.cid`

MEANGOTMP:
	echo `mktemp -d --suffix=.meango`>MEANGOTMP

MEANSHOPTMP:
	echo `mktemp -d --suffix=.meanshop`>MEANSHOPTMP

meango.cid: MEANGOTMP
	$(eval MEANGOTMP := $(shell cat MEANGOTMP))
	$(eval NAME := $(shell cat NAME))
	@docker run --name=$(NAME)-meango \
	--cidfile="meango.cid" \
	-v $(MEANGOTMP):/data/db \
	-d \
	-t mongo:3.2

tmpcleaner:
	rm MEANSHOPTMP
	rm MEANGOTMP

serve:
	sudo systemctl start mongodb
	grunt serve
