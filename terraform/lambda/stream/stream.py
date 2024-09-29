import json
import boto3
import os

dynamo = boto3.resource('dynamodb')
apigatewaymanagementapi = boto3.client('apigatewaymanagementapi', 
    endpoint_url=os.environ['WEBSOCKET_ENDPOINT']) 
orders_table_name = os.environ['ORDERS_TABLE_NAME']

def lambda_handler(event, context):
    connections_table_name = os.environ['CONNECTIONS_TABLE_NAME'] 
    connections_table = dynamo.Table(connections_table_name)

    orders_table = dynamo.Table(orders_table_name)
    order_results = orders_table.scan()

    single_client = event.get('client_id')
    
    connection_ids = [single_client] if single_client else [item['connectionId'] for item in connections_table.scan()['Items']] 

    if not single_client:
        for connection_id in connection_ids:
            for record in event.get("Records"):
                if record.get('eventName') == 'INSERT':
                    new_item = record['dynamodb']['NewImage']
                    message = {
                        'action': 'newOrder',
                        'order': {
                            'orderId': new_item['order_id']['S'],
                            'customerName': new_item['customer_name']['S'],
                            'coffeeType': new_item['item']['S'],
                            'milkType': new_item['milk_type']['S'],
                            'notes': new_item['extra_note']['S'],
                            'time': new_item['time']['S']
                        }
                    }
                elif record.get('eventName') == 'REMOVE':
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

    sorted_orders = sorted(order_results["Items"], key=lambda x: x['time'])
    for order in sorted_orders:
        for connection_id in connection_ids:
            message = {
                    'action': 'newOrder',
                    'order': {
                        'orderId': order['order_id'],
                        'customerName': order['customer_name'],
                        'coffeeType': order['item'],
                        'milkType': order['milk_type'],
                        'notes': order['extra_note'],
                        'time': order['time']
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
