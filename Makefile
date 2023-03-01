deploy:
	echo "-- deploy start. ----------------"
	echo "-- ecr login ----------------"
	aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.ap-northeast-1.amazonaws.com
	echo "-- docker build ----------------"
	docker build -t pymecab-lambda-container-dev ./
	docker tag pymecab-lambda-container-dev:latest $(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.ap-northeast-1.amazonaws.com/test:latest
	echo "-- docker push for ecr ----------------"
	docker push $(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.ap-northeast-1.amazonaws.com/test:latest
	echo "-- sls deploy ----------------"
	sls deploy
	echo "-- deploy end. ----------------"

remove:
	echo "-- sls remove ----------------"
	sls remove
