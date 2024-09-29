import os
import logging
import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Create DynamoDB client
dynamodb_client = boto3.client('dynamodb')
dynamodb_resource = boto3.resource('dynamodb')
connections_table_name = os.environ['CONNECTIONS_TABLE_NAME']

def lambda_handler(event, context):
    table = dynamodb_resource.Table(connections_table_name)
    
    try:
        response = table.delete_item(
            Key={
                'connectionId': event['requestContext']['connectionId']
            }
        )
    except ClientError as e:
        logger.error(e.response['Error']['Message'])
        return {
            'statusCode': 500
        }
    
    return {
        'statusCode': 200
    }
