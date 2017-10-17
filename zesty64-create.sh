#!/bin/bash

DIR=`dirname $0`
VLPHOME="$HOME/.vpn-launchpad"

AMIID="ami-fb58869d"
PROFILE="default"
REGION="ap-northeast-1"


echo "Creating Security Group..."
SGID=`aws --profile $PROFILE --region $REGION --output text ec2 create-security-group --group-name zesty64docker-sg --description 'security group for zesty64 docker environment in EC2'`
#aws --profile $PROFILE --region $REGION --output text ec2 describe-security-groups


echo "Creating Firewall rules..."
aws --profile $PROFILE --region $REGION --output text ec2 authorize-security-group-ingress --group-name zesty64docker-sg --protocol tcp --port 22 --cidr 0.0.0.0/0
aws --profile $PROFILE --region $REGION --output text ec2 authorize-security-group-ingress --group-name zesty64docker-sg --protocol udp --port 500 --cidr 0.0.0.0/0
aws --profile $PROFILE --region $REGION --output text ec2 authorize-security-group-ingress --group-name zesty64docker-sg --protocol udp --port 4500 --cidr 0.0.0.0/0
aws --profile $PROFILE --region $REGION --output text ec2 authorize-security-group-ingress --group-name zesty64docker-sg --protocol tcp --port 1701 --cidr 0.0.0.0/0
aws --profile $PROFILE --region $REGION --output text ec2 authorize-security-group-ingress --group-name zesty64docker-sg --protocol udp --port 1194 --cidr 0.0.0.0/0
aws --profile $PROFILE --region $REGION --output text ec2 authorize-security-group-ingress --group-name zesty64docker-sg --protocol tcp --port 5555 --cidr 0.0.0.0/0
#aws --profile $PROFILE --region $REGION --output text ec2 describe-security-groups --group-name zesty64docker-sg


echo "Creating Key-Pair..."
if [ ! -d "$VLPHOME" ]; then
	mkdir $VLPHOME
fi
aws --profile $PROFILE --region $REGION ec2 create-key-pair --key-name zesty64docker-key --query 'KeyMaterial' --output text > $VLPHOME/zesty64docker-key.pem
chmod 600 $VLPHOME/zesty64docker-key.pem


echo "Creating instance..."
INSTID=`aws --profile $PROFILE --region $REGION --output text ec2 run-instances --image-id $AMIID --security-group-ids $SGID --count 1 --instance-type t2.nano --key-name zesty64docker-key --query 'Instances[0].InstanceId'`
echo $INSTID


echo "Waiting for instance creation..."
while true; do
  sleep 10
  IPPUB=`aws --profile $PROFILE --region $REGION ec2 describe-instances --instance-ids $INSTID --query 'Reservations[0].Instances[0].PublicIpAddress'`
  if [ "$IPPUB" != "" ]; then
    break;
  fi
done


echo "Taging..."
aws --profile $PROFILE --region $REGION ec2 create-tags --resources $INSTID --tags 'Key=Name,Value=Zesty64Docker'


IPPUB=`aws --profile $PROFILE --region $REGION --output text ec2 describe-instances --instance-ids $INSTID --query 'Reservations[0].Instances[0].PublicIpAddress'`
echo $IPPUB


echo "Waiting for SSH up..."
while true; do
  sleep 5
  nc -zv $IPPUB 22
  if [ "$?" -eq "0" ]; then
    break;
  fi
done

echo "Instance provisioning..."
ssh-keyscan -H $IPPUB >> ~/.ssh/known_hosts
ssh -i $VLPHOME/zesty64docker-key.pem ubuntu@$IPPUB "sudo apt-get -y update; sudo apt-get install -y docker.io python-pip git"
ssh -i $VLPHOME/zesty64docker-key.pem ubuntu@$IPPUB "sudo sh -c \"echo '\n\nnet.core.default_qdisc=fq'>>/etc/sysctl.conf\""
ssh -i $VLPHOME/zesty64docker-key.pem ubuntu@$IPPUB "sudo sh -c \"echo '\nnet.ipv4.tcp_congestion_control=bbr'>>/etc/sysctl.conf\""
ssh -i $VLPHOME/zesty64docker-key.pem ubuntu@$IPPUB "sudo sysctl -p"
ssh -i $VLPHOME/zesty64docker-key.pem ubuntu@$IPPUB "sudo usermod -aG docker ubuntu"
scp -i $VLPHOME/zesty64docker-key.pem -r $DIR/docker-sevpn ubuntu@$IPPUB:
ssh -i $VLPHOME/zesty64docker-key.pem ubuntu@$IPPUB "cd docker-sevpn; cat sevpn.sh; sh sevpn.sh"

echo
echo "New Instance is up on $IPPUB"
echo "Enjoy."
