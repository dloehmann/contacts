#!/bin/sh


cd $TRAVIS_BUILD_DIR/contacts-backend
docker build -t deloehmann/contacts-backend:latest -t deloehmann/contacts-backend:$BUILD_ID -f ./Dockerfile .
cd $TRAVIS_BUILD_DIR
ls -l
echo $PWD
docker build -t deloehmann/contacts-frontend:latest -t deloehmann/contacts-frontend:$BUILD_ID -f ./contacts-frontend/Dockerfile ./contacts-frontend
docker push deloehmann/contacts-backend:latest
docker push deloehmann/contacts-frontend:latest

docker push deloehmann/contacts-backend:$BUILD_ID
docker push deloehmann/contacts-frontend:$BUILD_ID

kubectl apply -f ./contacts-deployment/k8s
kubectl set image deployments/contact-frontend-deployment contacts-frontend=deloehmann/contacts-frontend:$BUILD_ID
kubectl set image deployments/contact-backend-deployment contacts-api=deloehmann/contacts-backend:$BUILD_ID
