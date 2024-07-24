# set AWS account credentials
export AWS_ACCESS_KEY_ID= #your aws access key 
export AWS_SECRET_ACCESS_KEY= # your aws secret key

terraform init
terraform apply

cd pyAppFolder
docker build -t python_app .
docker tag python_app:latest 844077195878.dkr.ecr.eu-north-1.amazonaws.com/python_app:latest
docker push 844077195878.dkr.ecr.eu-north-1.amazonaws.com/python_app:latest
#docker run -d -p 8080:8080 --name python_app python_app

cd ../nginxFolder
docker build -t nginx_app .
docker tag nginx_app:latest 844077195878.dkr.ecr.eu-north-1.amazonaws.com/nginx_app:latest
docker push 844077195878.dkr.ecr.eu-north-1.amazonaws.com/nginx_app:latest
#docker run -d -p 80:80 --name nginx_app --link python_app:python_app nginx_app

# docker build -t nginx_app .
# docker tag nginx_app:latest 844077195878.dkr.ecr.eu-north-1.amazonaws.com/nginx_app:latest
# docker push 844077195878.dkr.ecr.eu-north-1.amazonaws.com/nginx_app:latest

# we could use dns route 53 to set hostname resolve so we can use with certificate

# Minikube
minikube start
minikube status
minikube dashboard
minikube ip
minikube ssh
