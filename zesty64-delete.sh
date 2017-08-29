#!/bin/bash

AMIID="ami-d511e5b3"
PROFILE="default"
REGION="ap-northeast-1"

INSTID=`aws --profile $PROFILE --region $REGION --output text ec2 describe-instances --filters "Name=key-name,Values=zesty64docker-key" --query 'Reservations[].Instances[0].InstanceId'`

echo "Waiting for instance deletion..."
sleep 10
echo "aws --profile $PROFILE --region $REGION --output text ec2 terminate-instances --instance-id $INSTID"
aws --profile $PROFILE --region $REGION --output text ec2 terminate-instances --instance-id $INSTID


aws --profile $PROFILE --region $REGION --output text ec2 delete-security-group --group-name zesty64docker-sg


rm -rf zesty64docker-key.pem
aws --profile $PROFILE --region $REGION --output text ec2 delete-key-pair --key-name zesty64docker-key
