import json
import boto3
import os

# Initialize the AWS SDK clients
dynamo = boto3.resource('dynamodb')
apigatewaymanagementapi = boto3.client('apigatewaymanagementapi', 
    endpoint_url=os.environ['WEBSOCKET_ENDPOINT'])  # Set in Lambda environment variables
# Replace with your DynamoDB table name
orders_table_name = os.environ['ORDERS_TABLE_NAME']

def lambda_handler(event, context):
    # Assuming you have stored connection IDs in a DynamoDB table
    connections_table_name = os.environ['CONNECTIONS_TABLE_NAME']  # Change this to your connection table name
    connections_table = dynamo.Table(connections_table_name)
    orders_table = dynamo.Table(orders_table_name)
    order_results = orders_table.scan()
    # Prepare the message to send

    single_client = event.get('client_id')
    # Scan to get all connection IDs
    
    connection_ids = [single_client] if single_client else [item['connectionId'] for item in connections_table.scan()['Items']] 

    if not single_client:
        for connection_id in connection_ids:
            for record in event.get("Records"):
                if record.get('eventName', None) == 'INSERT':
                    # This is a new item added to the DynamoDB table
                    new_item = record['dynamodb']['NewImage']
                    message = {
                        'action': 'newOrder',
                        'order': {
                            'orderId': new_item['order_id']['S'],
                            'customerName': new_item['customer_name']['S'],
                            'coffeeType': new_item['item']['S'],
                            'milkType': new_item['milk_type']['S'],
                            'notes': new_item['extra_note']['S']
                        }
                    }
                elif record.get('eventName', None) == 'REMOVE':
                    new_item = record['dynamodb']['Keys']
                    message = {
                        'action': 'removeOrder',
                        'order': {
                            'orderId': new_item['order_id']['S'],
                        }
                    }
                post(message, connection_id)
        return {
            'statusCode': 200
        }

    print(connection_ids)
    print(single_client)

    for order in order_results["Items"]:
        for connection_id in connection_ids:
            message = {
                    'action': 'newOrder',
                    'order': {
                        'orderId': order['order_id'],
                        'customerName': order['customer_name'],
                        'coffeeType': order['item'],
                        'milkType': order['milk_type'],
                        'notes': order['extra_note']
                    }
                }
            post(message, connection_id)
           
def post(message, connection_id):
    try:         
        apigatewaymanagementapi.post_to_connection(
            ConnectionId=connection_id,
            Data=json.dumps(message).encode('utf-8')
        )
        print(f'Message sent to {connection_id}')
    except Exception as e:
        print(f'Error sending message to {connection_id}: {e}')
