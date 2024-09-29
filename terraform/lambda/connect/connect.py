import os
import logging
import boto3
import json 

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb_resource = boto3.resource('dynamodb')
connections_table_name = os.environ['CONNECTIONS_TABLE_NAME']
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
            InvocationType='Event',
            Payload=json.dumps({'client_id': connection_id}))
    return {
        'statusCode': 200
    }
