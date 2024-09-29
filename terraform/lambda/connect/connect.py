import os
import logging
import boto3
import json 

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Create DynamoDB client
dynamodb_client = boto3.client('dynamodb')
dynamodb_resource = boto3.resource('dynamodb')
connections_table_name = os.environ['CONNECTIONS_TABLE_NAME']
apigatewaymanagementapi = boto3.client('apigatewaymanagementapi', 
    endpoint_url=os.environ['WEBSOCKET_ENDPOINT'])  # Set in Lambda environment variables
orders_table_name = os.environ['ORDERS_TABLE_NAME']  # Change this to your actual orders table name
lambda_client = boto3.client('lambda')


def lambda_handler(event, context):
    table = dynamodb_resource.Table(connections_table_name)
    connection_id = event['requestContext']['connectionId']
    try:
        table.put_item(
            Item={
                'connectionId': connection_id
            }
        )
    except Exception as e:
        logger.error(e.response['Error']['Message'])
        return {
            'statusCode': 500
        }
    lambda_client.invoke(
            FunctionName="pos-stream",
            InvocationType='Event',  # Use 'Event' for asynchronous invocation
            Payload=json.dumps({'client_id': connection_id}))
    return {
        'statusCode': 200
    }
