
DWD=${CURDIR}
.PHONY: build

default: run-locally-windows

build-windows:
	@ ${MAKE} build-rails-app
	@ ${MAKE} build-nginx
	@ ${MAKE} tag-rails-app
	@ ${MAKE} tag-nginx
	@ ${MAKE} push-rails-app
	@ ${MAKE} push-nginx
	@ ${MAKE} run-docker-compose

build:
	@ ${MAKE} build-rails-app
	@ ${MAKE} build-nginx
	@ ${MAKE} tag-rails-app
	@ ${MAKE} tag-nginx
	@ ${MAKE} push-rails-app
	@ ${MAKE} docker-login
	@ ${MAKE} push-nginx
	@ ${MAKE} run-docker-compose

run-locally-windows:
	@ ${MAKE} run-docker-compose-dev

run-locally-linux:
	@ ${MAKE} run-docker-compose-dev

#this function creates the ssl certificates on non-windows machines
generate-ssl-certificates:
	@ openssl req -new -newkey rsa:2048 -sha1 -days 365 -nodes -x509 -keyout ${DWD}/nginx/.ssl/myco.key -out ${DWD}/nginx/.ssl/myco.crt -config ${DWD}/nginx/.ssl/req.cnf


#this function run docker images for local testing not to be used on Jenkins CI
run-docker-compose-dev:
	@ docker-compose -f docker-compose-dev.yml up -d --force-recreate

#this function run build for local testing
run-docker-compose:
	@ docker-compose -f docker-compose.yml up -d --force-recreate

build-rails-app:
	@ docker build -t ${DOCKER_REPO_URL}/rails-app app-code/.

build-nginx:
	@ docker build -t ${DOCKER_REPO_URL}/nginx nginx/.

tag-nginx:
	@ docker tag ${DOCKER_REPO_URL}/nginx:latest ${DOCKER_REPO_URL}/nginx:latest

tag-rails-app:
	@ docker tag ${DOCKER_REPO_URL}/rails-app:latest ${DOCKER_REPO_URL}/rails-app:latest

push-rails-app:
	@ docker push ${DOCKER_REPO_URL}/rails-app:latest

push-nginx:
	@ docker push ${DOCKER_REPO_URL}/nginx:latest

docker-login:
	@  docker login --username=${DOCKER_REPO_URL} --password=${DOCKER_REPO_PWD}

owsp-testing:
	@  echo "owasp testing"

docker-scanning:
	@  echo "docker scanning"

clean-up:    
		@ docker stop $(docker ps -qa)
		@ docker rm   $(docker ps -qa)
		@ docker rmi ${DOCKER_REPO_URL}/nginx
		@ docker rmi ${DOCKER_REPO_URL}/rails-ap
