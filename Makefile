ECRREPOURI	:= "776072350111.dkr.ecr.us-west-2.amazonaws.com/pm2-express-demo"
SECURITY_GROUP_ID	:= "sg-bc2b14c5"

build:
	docker build -t pm2-express-demo .
build-pm2:
	docker build -t pm2-express-demo:pm2 -f Dockerfile.pm2 .
run:
	docker run -ti -p 8080:8080 pm2-express-demo:latest
run-pm2:
	docker run -ti -p 8080:8080 pm2-express-demo:pm2
tag:
	docker tag pm2-express-demo:latest $(ECRREPOURI)
push:
	docker push $(ECRREPOURI)
alb:
	fargate --region us-west-2 lb create demoalb -p 80 --security-group-id $(SECURITY_GROUP_ID)
service:
	fargate --region us-west-2 service create demoexpress -l demoalb -p http:8080 -i $(ECRREPOURI) --security-group-id $(SECURITY_GROUP_ID)
dns:
	fargate --region us-west-2 service info demoexpress