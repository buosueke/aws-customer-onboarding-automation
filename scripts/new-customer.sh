#!/bin/bash
set -e

[ "$#" -eq 5 ] || { echo "Usage: $0 \"Customer Name\" INSTANCE_TYPE BUCKET_NAME IAM_USER RECORD_NAME"; exit 1; }

CUSTOMER_NAME="$1"
INSTANCE_TYPE="$2"
BUCKET_NAME="$3"
IAM_USER="$4"
RECORD_NAME="$5"

HOSTED_ZONE_ID="ZXXXXXXXXXXXXX"
HOSTED_ZONE_NAME="exampledomain.com"
STACK_NAME="cust-$BUCKET_NAME"
TEMPLATE="customer-onboard.yml"

aws cloudformation deploy \
  --stack-name "$STACK_NAME" \
  --template-file "$TEMPLATE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    CustomerName="$CUSTOMER_NAME" \
    InstanceType="$INSTANCE_TYPE" \
    BucketName="$BUCKET_NAME" \
    IamUserName="$IAM_USER" \
    RecordName="$RECORD_NAME" \
    HostedZoneId="$HOSTED_ZONE_ID" \
    HostedZoneName="$HOSTED_ZONE_NAME"

INSTANCE_ID="$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" \
  --query "Stacks[0].Outputs[?OutputKey=='InstanceId'].OutputValue" --output text)"

FQDN="$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" \
  --query "Stacks[0].Outputs[?OutputKey=='RecordFQDN'].OutputValue" --output text)"

echo "Done: $STACK_NAME"
echo "DNS:  $FQDN"
echo "EC2:  $INSTANCE_ID"
