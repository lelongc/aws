import boto3
import json
import logging
import uuid
from botocore.exceptions import ClientError

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize SNS and SQS clients
sns_client = boto3.client('sns')
sqs_client = boto3.client('sqs')

# SNS Operations
def create_sns_topic(name):
    """Create an SNS topic"""
    try:
        response = sns_client.create_topic(Name=name)
        topic_arn = response['TopicArn']
        logger.info(f"Created SNS topic {name} with ARN {topic_arn}")
        return topic_arn
    except ClientError as e:
        logger.error(f"Error creating SNS topic {name}: {e}")
        return None

def delete_sns_topic(topic_arn):
    """Delete an SNS topic"""
    try:
        sns_client.delete_topic(TopicArn=topic_arn)
        logger.info(f"Deleted SNS topic {topic_arn}")
        return True
    except ClientError as e:
        logger.error(f"Error deleting SNS topic {topic_arn}: {e}")
        return False

def list_sns_topics():
    """List all SNS topics"""
    try:
        response = sns_client.list_topics()
        topics = response.get('Topics', [])
        
        topic_data = []
        for topic in topics:
            topic_data.append({
                'TopicArn': topic['TopicArn'],
                'TopicName': topic['TopicArn'].split(':')[-1]
            })
            
        logger.info(f"Found {len(topic_data)} SNS topics")
        return topic_data
    except ClientError as e:
        logger.error(f"Error listing SNS topics: {e}")
        return []

def publish_sns_message(topic_arn, message, subject=None, attributes=None):
    """Publish a message to an SNS topic"""
    try:
        kwargs = {
            'TopicArn': topic_arn,
            'Message': message
        }
        
        if subject:
            kwargs['Subject'] = subject
            
        if attributes:
            kwargs['MessageAttributes'] = attributes
            
        response = sns_client.publish(**kwargs)
        message_id = response['MessageId']
        logger.info(f"Published message {message_id} to topic {topic_arn}")
        return message_id
    except ClientError as e:
        logger.error(f"Error publishing to SNS topic {topic_arn}: {e}")
        return None

def subscribe_to_sns_topic(topic_arn, protocol, endpoint):
    """
    Subscribe to an SNS topic
    
    Parameters:
    - topic_arn: ARN of the SNS topic
    - protocol: Protocol for subscription (e.g., 'sqs', 'lambda', 'email', 'http')
    - endpoint: Endpoint for subscription (e.g., SQS ARN, Lambda ARN, email address)
    """
    try:
        response = sns_client.subscribe(
            TopicArn=topic_arn,
            Protocol=protocol,
            Endpoint=endpoint
        )
        subscription_arn = response['SubscriptionArn']
        logger.info(f"Subscribed {endpoint} to topic {topic_arn} with ARN {subscription_arn}")
        return subscription_arn
    except ClientError as e:
        logger.error(f"Error subscribing to SNS topic {topic_arn}: {e}")
        return None

def unsubscribe_from_sns_topic(subscription_arn):
    """Unsubscribe from an SNS topic"""
    try:
        sns_client.unsubscribe(SubscriptionArn=subscription_arn)
        logger.info(f"Unsubscribed from subscription {subscription_arn}")
        return True
    except ClientError as e:
        logger.error(f"Error unsubscribing from {subscription_arn}: {e}")
        return False

def list_sns_subscriptions(topic_arn=None):
    """
    List SNS subscriptions
    
    Parameters:
    - topic_arn: Optional topic ARN to filter by
    """
    try:
        if topic_arn:
            response = sns_client.list_subscriptions_by_topic(TopicArn=topic_arn)
        else:
            response = sns_client.list_subscriptions()
            
        subscriptions = response.get('Subscriptions', [])
        
        subscription_data = []
        for sub in subscriptions:
            subscription_data.append({
                'SubscriptionArn': sub['SubscriptionArn'],
                'Protocol': sub['Protocol'],
                'Endpoint': sub['Endpoint'],
                'TopicArn': sub['TopicArn']
            })
            
        logger.info(f"Found {len(subscription_data)} SNS subscriptions")
        return subscription_data
    except ClientError as e:
        logger.error(f"Error listing SNS subscriptions: {e}")
        return []

# SQS Operations
def create_sqs_queue(name, attributes=None):
    """
    Create an SQS queue
    
    Parameters:
    - name: Name of the queue
    - attributes: Dictionary of queue attributes
    """
    try:
        kwargs = {'QueueName': name}
        
        if attributes:
            kwargs['Attributes'] = attributes
            
        response = sqs_client.create_queue(**kwargs)
        queue_url = response['QueueUrl']
        logger.info(f"Created SQS queue {name} with URL {queue_url}")
        return queue_url
    except ClientError as e:
        logger.error(f"Error creating SQS queue {name}: {e}")
        return None

def delete_sqs_queue(queue_url):
    """Delete an SQS queue"""
    try:
        sqs_client.delete_queue(QueueUrl=queue_url)
        logger.info(f"Deleted SQS queue {queue_url}")
        return True
    except ClientError as e:
        logger.error(f"Error deleting SQS queue {queue_url}: {e}")
        return False

def list_sqs_queues(name_prefix=None):
    """List SQS queues with optional name prefix"""
    try:
        kwargs = {}
        if name_prefix:
            kwargs['QueueNamePrefix'] = name_prefix
            
        response = sqs_client.list_queues(**kwargs)
        queues = response.get('QueueUrls', [])
        
        logger.info(f"Found {len(queues)} SQS queues")
        return queues
    except ClientError as e:
        logger.error(f"Error listing SQS queues: {e}")
        return []

def get_queue_attributes(queue_url, attribute_names=None):
    """Get attributes of an SQS queue"""
    try:
        if not attribute_names:
            attribute_names = ['All']
            
        response = sqs_client.get_queue_attributes(
            QueueUrl=queue_url,
            AttributeNames=attribute_names
        )
        
        attributes = response.get('Attributes', {})
        logger.info(f"Retrieved attributes for queue {queue_url}")
        return attributes
    except ClientError as e:
        logger.error(f"Error getting attributes for queue {queue_url}: {e}")
        return {}

def get_queue_arn(queue_url):
    """Get the ARN of an SQS queue"""
    try:
        response = sqs_client.get_queue_attributes(
            QueueUrl=queue_url,
            AttributeNames=['QueueArn']
        )
        
        return response['Attributes']['QueueArn']
    except ClientError as e:
        logger.error(f"Error getting ARN for queue {queue_url}: {e}")
        return None

def send_sqs_message(queue_url, message, message_attributes=None, delay_seconds=0):
    """Send a message to an SQS queue"""
    try:
        kwargs = {
            'QueueUrl': queue_url,
            'MessageBody': message,
            'DelaySeconds': delay_seconds
        }
        
        if message_attributes:
            kwargs['MessageAttributes'] = message_attributes
            
        response = sqs_client.send_message(**kwargs)
        message_id = response['MessageId']
        logger.info(f"Sent message {message_id} to queue {queue_url}")
        return message_id
    except ClientError as e:
        logger.error(f"Error sending message to queue {queue_url}: {e}")
        return None

def receive_sqs_messages(queue_url, max_messages=1, wait_time=0, visibility_timeout=30):
    """
    Receive messages from an SQS queue
    
    Parameters:
    - queue_url: URL of the queue
    - max_messages: Maximum number of messages to receive (1-10)
    - wait_time: Long polling wait time in seconds (0-20)
    - visibility_timeout: Visibility timeout for received messages
    """
    try:
        response = sqs_client.receive_message(
            QueueUrl=queue_url,
            MaxNumberOfMessages=max_messages,
            WaitTimeSeconds=wait_time,
            VisibilityTimeout=visibility_timeout,
            AttributeNames=['All'],
            MessageAttributeNames=['All']
        )
        
        messages = response.get('Messages', [])
        logger.info(f"Received {len(messages)} messages from queue {queue_url}")
        return messages
    except ClientError as e:
        logger.error(f"Error receiving messages from queue {queue_url}: {e}")
        return []

def delete_sqs_message(queue_url, receipt_handle):
    """Delete a message from an SQS queue"""
    try:
        sqs_client.delete_message(
            QueueUrl=queue_url,
            ReceiptHandle=receipt_handle
        )
        logger.info(f"Deleted message from queue {queue_url}")
        return True
    except ClientError as e:
        logger.error(f"Error deleting message from queue {queue_url}: {e}")
        return False

def purge_sqs_queue(queue_url):
    """Remove all messages from an SQS queue"""
    try:
        sqs_client.purge_queue(QueueUrl=queue_url)
        logger.info(f"Purged queue {queue_url}")
        return True
    except ClientError as e:
        logger.error(f"Error purging queue {queue_url}: {e}")
        return False

# Combined SNS-SQS Operations
def create_sns_to_sqs_subscription(topic_name, queue_name):
    """
    Create an SNS topic and SQS queue, and subscribe the queue to the topic
    
    Returns:
    - Dictionary with topic_arn, queue_url, and subscription_arn
    """
    try:
        # Create SNS topic
        topic_arn = create_sns_topic(topic_name)
        if not topic_arn:
            return None
            
        # Create SQS queue
        queue_url = create_sqs_queue(queue_name)
        if not queue_url:
            delete_sns_topic(topic_arn)
            return None
            
        # Get queue ARN and set queue policy to allow SNS
        queue_arn = get_queue_arn(queue_url)
        
        # Set SQS policy to allow SNS messages
        policy = {
            'Version': '2012-10-17',
            'Statement': [
                {
                    'Effect': 'Allow',
                    'Principal': {'Service': 'sns.amazonaws.com'},
                    'Action': 'sqs:SendMessage',
                    'Resource': queue_arn,
                    'Condition': {
                        'ArnEquals': {'aws:SourceArn': topic_arn}
                    }
                }
            ]
        }
        
        sqs_client.set_queue_attributes(
            QueueUrl=queue_url,
            Attributes={'Policy': json.dumps(policy)}
        )
        
        # Subscribe queue to topic
        subscription_arn = subscribe_to_sns_topic(topic_arn, 'sqs', queue_arn)
        
        logger.info(f"Created SNS-SQS subscription between {topic_arn} and {queue_url}")
        return {
            'topic_arn': topic_arn,
            'queue_url': queue_url,
            'subscription_arn': subscription_arn
        }
    except Exception as e:
        logger.error(f"Error creating SNS-SQS subscription: {e}")
        return None

def send_and_receive_via_sns_sqs(topic_arn, queue_url, message):
    """
    Send a message to an SNS topic and receive it from a subscribed SQS queue
    
    Returns:
    - Received message if successful, None otherwise
    """
    try:
        # Publish message to SNS topic
        message_id = publish_sns_message(topic_arn, message)
        if not message_id:
            return None
            
        # Wait a moment for message to propagate
        import time
        time.sleep(2)
        
        # Receive message from SQS queue
        messages = receive_sqs_messages(queue_url, wait_time=10)
        
        if not messages:
            logger.warning("No messages received from queue")
            return None
            
        # Process and delete the message
        for msg in messages:
            body = json.loads(msg['Body'])
            if 'MessageId' in body and body.get('Message') == message:
                delete_sqs_message(queue_url, msg['ReceiptHandle'])
                return body
                
        logger.warning("Received messages but none matched the sent message")
        return None
    except Exception as e:
        logger.error(f"Error in send-receive via SNS-SQS: {e}")
        return None

# Example usage
if __name__ == "__main__":
    # Create a unique identifier for resource names
    uid = str(uuid.uuid4())[:8]
    
    # Create an SNS topic and SQS queue setup
    setup = create_sns_to_sqs_subscription(f"test-topic-{uid}", f"test-queue-{uid}")
    
    if setup:
        # Send a message and try to receive it
        message = f"Test message {uid}"
        result = send_and_receive_via_sns_sqs(
            setup['topic_arn'],
            setup['queue_url'],
            message
        )
        
        if result:
            print(f"Successfully sent and received message via SNS-SQS")
            print(f"Message: {result['Message']}")
            
        # Clean up
        unsubscribe_from_sns_topic(setup['subscription_arn'])
        delete_sns_topic(setup['topic_arn'])
        delete_sqs_queue(setup['queue_url'])
