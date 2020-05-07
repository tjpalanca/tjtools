# Application Information
APP=$(subst Package: ,,$(shell grep "Package: " DESCRIPTION))
VER=$(subst Version: ,,$(shell grep "Version: " DESCRIPTION))
REP=tjpalanca/apps:$(APP)
PRT=3838

ENVIRONMENT= \
	--env "TJTOOLS_PASSWORD=$(TJTOOLS_PASSWORD)"

# Calculated
NODENAME = $(shell kubectl get pod $(HOSTNAME) -o=jsonpath={'.spec.nodeName'})
REP_VER=tjpalanca/apps:tjtools-$(VER)
REP_LAT=tjpalanca/apps:tjtools-latest

# Pull docker image
docker-pull:
	# Dash is to ignore if it doesn't exist
	-docker pull $(REP_LAT)

# Builds the docker image for this particular version
docker-build:
	docker build \
		--cache-from=$(REP_VER) \
		--cache-from=$(REP_LAT) \
	    -t $(REP_VER) .

# Shell into your docker container
docker-shell:
	docker run -it --rm $(REP_VER) bash

# Publishes the built docker image to Docker Hub
docker-publish:
	docker tag $(REP_VER) $(REP_LAT) && \
	docker push $(REP_LAT) && \
	docker push $(REP_VER)

# Test your application on a test URL
kube-test-start:
	kubectl run $(APP) \
		--generator=run-pod/v1 \
		--image=$(REP_VER) \
		--port=$(PRT) \
		$(ENVIRONMENT) \
		--overrides='{"apiVersion": "v1", "spec": { "nodeName" : "$(NODENAME)" } }' && \
	kubectl expose pod/$(APP) \
		--name=test \
		--port=80 \
		--target-port=$(PRT)

# Stop testing your application
kube-test-stop:
	kubectl delete svc/test & \
	kubectl delete pod/$(APP)

# Restart through iterative testing
kube-test-restart:
	make kube-test-stop && \
	make docker-build && \
	make kube-test-start

# Surface logs
kube-logs:
	kubectl logs $(APP)
