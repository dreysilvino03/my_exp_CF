#!/usr/bin/env bash

STACK_NAME=$1-VPC


echo "Checking stack ${STACK_NAME} already exists"
aws cloudformation describe-stacks --stack-name ${STACK_NAME}
echo "Creating stack..."
STACK_ID=$( \
  aws cloudformation create-stack \
  --stack-name ${STACK_NAME} \
  --template-body file://vpc.yml \
  --capabilities CAPABILITY_IAM \
  --parameters file://prod-parameters.json \
  | jq -r .StackId \
)

echo "Waiting on ${STACK_ID} create completion..."
aws cloudformation wait stack-create-complete --stack-name ${STACK_ID}

STACK_NAME=$1-Cloudmap

echo "Checking stack ${STACK_NAME} already exists"
aws cloudformation describe-stacks --stack-name ${STACK_NAME}
echo "Creating stack..."
STACK_ID=$( \
  aws cloudformation create-stack \
  --stack-name ${STACK_NAME} \
  --template-body file://cloudmap.yml \
  --capabilities CAPABILITY_IAM \
  --parameters file://prod-parameters.json \
  | jq -r .StackId \
)

echo "Waiting on ${STACK_ID} create completion..."
aws cloudformation wait stack-create-complete --stack-name ${STACK_ID}


STACK_NAME=$1-LB

echo "Checking stack ${STACK_NAME} already exists"
aws cloudformation describe-stacks --stack-name ${STACK_NAME}
echo "Creating stack..."
STACK_ID=$( \
  aws cloudformation create-stack \
  --stack-name ${STACK_NAME} \
  --template-body file://load-balancers.yml \
  --capabilities CAPABILITY_IAM \
  --parameters file://prod-parameters.json \
  | jq -r .StackId \
)

echo "Waiting on ${STACK_ID} create completion..."
aws cloudformation wait stack-create-complete --stack-name ${STACK_ID}

STACK_NAME=$1-ECS

echo "Checking stack ${STACK_NAME} already exists"
aws cloudformation describe-stacks --stack-name ${STACK_NAME}
echo "Creating stack..."
STACK_ID=$( \
  aws cloudformation create-stack \
  --stack-name ${STACK_NAME} \
  --template-body file://cluster.yml \
  --capabilities CAPABILITY_IAM \
  --parameters file://prod-parameters.json \
  | jq -r .StackId \
)

echo "Waiting on ${STACK_ID} create completion..."
aws cloudformation wait stack-create-complete --stack-name ${STACK_ID}

STACK_NAME=$1-RDS


echo "Checking stack ${STACK_NAME} already exists"
aws cloudformation describe-stacks --stack-name ${STACK_NAME}
echo "Creating stack..."
STACK_ID=$( \
  aws cloudformation create-stack \
  --stack-name ${STACK_NAME} \
  --template-body file://postgreSQL.yml \
  --capabilities CAPABILITY_IAM \
  --parameters file://prod-parameters.json \
  | jq -r .StackId \
)

echo "Waiting on ${STACK_ID} create completion..."
aws cloudformation wait stack-create-complete --stack-name ${STACK_ID}

STACK_NAME=$1-Cloudtrail


echo "Checking stack ${STACK_NAME} already exists"
aws cloudformation describe-stacks --stack-name ${STACK_NAME}
echo "Creating stack..."
STACK_ID=$( \
  aws cloudformation create-stack \
  --stack-name ${STACK_NAME} \
  --template-body file://cloudtrail.yml \
  --capabilities CAPABILITY_IAM \
  | jq -r .StackId \
)

echo "Waiting on ${STACK_ID} create completion..."
aws cloudformation wait stack-create-complete --stack-name ${STACK_ID}


STACK_NAME=$1-Lambda


echo "Checking stack ${STACK_NAME} already exists"
aws cloudformation describe-stacks --stack-name ${STACK_NAME}
echo "Creating stack..."
STACK_ID=$( \
  aws cloudformation create-stack \
  --stack-name ${STACK_NAME} \
  --template-body file://lambda.yml \
  --capabilities CAPABILITY_IAM \
  | jq -r .StackId \
)

echo "Waiting on ${STACK_ID} create completion..."
aws cloudformation wait stack-create-complete --stack-name ${STACK_ID}
