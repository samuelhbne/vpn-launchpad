#!/bin/bash

DIR=`dirname $0`
VLPHOME="$HOME/.vpn-launchpad"

AMIID="ami-fb58869d"
PROFILE="default"
REGION="ap-northeast-1"

echo "Querying Instance..."
INSTID=`aws --profile $PROFILE --region $REGION --output text ec2 describe-instances --filters "Name=key-name,Values=zesty64docker-key" --query 'Reservations[].Instances[0].InstanceId'`

echo "Deleting Instance..."
aws --profile $PROFILE --region $REGION --output text ec2 terminate-instances --instance-id $INSTID


for i in `seq 4 -1 0`; do
  echo "Waiting Instance shutdown..."
  sleep 5
  echo "Deleteing Security Group..."
  aws --profile $PROFILE --region $REGION --output text ec2 delete-security-group --group-name zesty64docker-sg
  if [ "$?" -eq "0" ]; then
    break;
  fi
  echo "Security Group deletion Failed. $i try left."
done


echo "Deleting SSH Key-Pair..."
aws --profile $PROFILE --region $REGION --output text ec2 delete-key-pair --key-name zesty64docker-key
rm -rf $VLPHOME/zesty64docker-key.pem

