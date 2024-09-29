import os
import json
import logging
import boto3
import uuid

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize DynamoDB and API Gateway clients
dynamodb = boto3.resource('dynamodb')
apigw_client = boto3.client('apigatewaymanagementapi')

orders_table_name = os.environ['ORDERS_TABLE_NAME']

def lambda_handler(event, context):
    
    logger.info(event)
    try:
        item = json.loads(event['body'])
        if item['action'] == 'add':
            table = dynamodb.Table(orders_table_name)
            table.put_item(
                    Item={
                        'order_id': f"{uuid.uuid4()}",
                        'customer_name': item['data']['order']['customerName'] or "Unspecified",
                        'item': item['data']['order']['coffee'] or "Flat White",
                        'milk_type': item['data']['order']['milkType'] or "regular",
                        'extra_note': item['data']['order']['extraNotes'] or "none"
                    }
                )
    except Exception as e:
        logger.error(e.response['Error']['Message'])
        return {
            'statusCode': 500
        }
    
    return {
        'statusCode': 200
    }
    
