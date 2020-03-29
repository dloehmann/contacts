#!/bin/sh


cd $TRAVIS_BUILD_DIR/contacts-backend
echo "cd $TRAVIS_BUILD_DIR/contacts-backend"
docker build -t dloehmann/contacts-backend:latest -t dloehmann/contacts-backend:$BUILD_ID -f ./Dockerfile .
echo "docker build -t dloehmann/contacts-backend:latest -t dloehmann/contacts-backend:$BUILD_ID -f ./Dockerfile ."
cd $TRAVIS_BUILD_DIR
echo "cd $TRAVIS_BUILD_DIR"
ls -l
echo "ls -l"
echo $PWD
echo "docker build -t dloehmann/contacts-frontend:latest -t dloehmann/contacts-frontend:$BUILD_ID -f ./contacts-frontend/Dockerfile ./contacts-frontend"
docker build -t dloehmann/contacts-frontend:latest -t dloehmann/contacts-frontend:$BUILD_ID -f ./contacts-frontend/Dockerfile ./contacts-frontend
echo "docker push dloehmann/contacts-backend:latest"
docker push dloehmann/contacts-backend:latest
docker push dloehmann/contacts-frontend:latest
echo "docker push dloehmann/contacts-frontend:latest"

docker push dloehmann/contacts-backend:$BUILD_ID
echo "docker push dloehmann/contacts-backend:$BUILD_ID"
docker push dloehmann/contacts-frontend:$BUILD_ID
echo "docker push dloehmann/contacts-frontend:$BUILD_ID"

echo "kubectl apply -f ./contacts-deployment/k8s"
kubectl apply -f ./contacts-deployment/k8s
echo "kubectl set image deployments/contact-frontend-deployment contacts-frontend=dloehmann/contacts-frontend:$BUILD_ID"
kubectl set image deployments/contact-frontend-deployment contacts-frontend=dloehmann/contacts-frontend:$BUILD_ID
echo "kubectl set image deployments/contact-backend-deployment contacts-api=dloehmann/contacts-backend:$BUILD_ID"
kubectl set image deployments/contact-backend-deployment contacts-api=dloehmann/contacts-backend:$BUILD_ID
