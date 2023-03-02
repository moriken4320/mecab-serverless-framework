include .env

deploy:
	echo "-- deploy start. ----------------"
	echo "-- ecr login ----------------"
	aws ecr get-login-password --region $(REGION) | docker login --username AWS --password-stdin $(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com
	echo "-- docker build ----------------"
	docker build -t pymecab-lambda-container-dev ./
	docker tag pymecab-lambda-container-dev:latest $(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/$(REPOSITORY):latest
	echo "-- docker push for ecr ----------------"
	docker push $(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/$(REPOSITORY):latest
	echo "-- sls deploy ----------------"
	sls deploy
	echo "-- deploy end. ----------------"

remove:
	echo "-- sls remove ----------------"
	sls remove
