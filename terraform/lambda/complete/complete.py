import os
import json
import logging
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
orders_table_name = os.environ['ORDERS_TABLE_NAME']
lambda_client = boto3.client('lambda')

def lambda_handler(event, context):
    orders_table = dynamodb.Table(orders_table_name)

    print(json.dumps(event))
    
    order_id = json.loads(event.get('body')).get('data').get('order').get('orderId')
    print(order_id)
    try:
        orders_table.delete_item(Key={"order_id": order_id})
    except Exception as e:
        logger.error(e.response['Error']['Message'])
        return {
            'statusCode': 500
        }

    return {
        'statusCode': 200
    }
