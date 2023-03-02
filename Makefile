include .env

prov-image:
	echo "-- ecr login ----------------"
	aws ecr get-login-password --region $(REGION) | docker login --username AWS --password-stdin $(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com
	echo "-- docker build ----------------"
	docker build -t pymecab-lambda-container-dev ./
	docker tag pymecab-lambda-container-dev:latest $(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/$(REPOSITORY):latest
	echo "-- docker push for ecr ----------------"
	docker push $(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/$(REPOSITORY):latest

init:
	@make prov-image
	echo "-- cf deploy ----------------"
	aws cloudformation deploy \
	--template-file template.yml \
	--stack-name $(STACK_NAME) \
	--capabilities CAPABILITY_NAMED_IAM \
	--parameter-overrides Repository=$(REPOSITORY) FunctionName=$(FUNCTION_NAME)

update:
	@make prov-image
	echo "-- lambda update ----------------"
	aws lambda update-function-code \
	--function-name $(FUNCTION_NAME) \
	--image-uri $(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/$(REPOSITORY):latest

remove:
	echo "-- cf delete ----------------"
	aws cloudformation delete-stack --stack-name $(STACK_NAME)
