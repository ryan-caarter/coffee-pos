import os
import json
import logging
import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    connection_id = event['requestContext']['connectionId']
    domain_name = event['requestContext']['domainName']
    stage = event['requestContext']['stage']
    
    apigw_endpoint = f"https://{domain_name}/{stage}"

    # Initialize API Gateway Management API client
    apigw_client = boto3.client('apigatewaymanagementapi', endpoint_url=apigw_endpoint)

    # Retrieve connection information
    try:
        connection_info = apigw_client.get_connection(ConnectionId=connection_id)
    except ClientError as e:
        logger.error(f"Error retrieving connection: {e.response['Error']['Message']}")
        return {
            'statusCode': 500
        }

    connection_info['connectionID'] = connection_id

    # Send message back to the connection
    message = 'Use the `add` route to send a message. Your info: ' + json.dumps(connection_info, default=str)
    
    try:
        apigw_client.post_to_connection(
            ConnectionId=connection_id,
            Data=message
        )
    except ClientError as e:
        logger.error(f"Error sending message: {e.response['Error']['Message']}")
        return {
            'statusCode': 500
        }

    return {
        'statusCode': 200
    }
