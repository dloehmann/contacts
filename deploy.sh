#!/bin/sh


cd $TRAVIS_BUILD_DIR/contacts-backend
docker build -t dloehmann/contacts-backend:latest -t dloehmann/contacts-backend:$BUILD_ID -f ./Dockerfile .
cd $TRAVIS_BUILD_DIR
ls -l
echo $PWD
docker build -t dloehmann/contacts-frontend:latest -t dloehmann/contacts-frontend:$BUILD_ID -f ./contacts-frontend/Dockerfile ./contacts-frontend
docker push dloehmann/contacts-backend:latest
docker push dloehmann/contacts-frontend:latest

docker push dloehmann/contacts-backend:$BUILD_ID
docker push dloehmann/contacts-frontend:$BUILD_ID

kubectl apply -f ./contacts-deployment/k8s
kubectl set image deployments/contact-frontend-deployment contacts-frontend=dloehmann/contacts-frontend:$BUILD_ID
kubectl set image deployments/contact-backend-deployment contacts-api=dloehmann/contacts-backend:$BUILD_ID
