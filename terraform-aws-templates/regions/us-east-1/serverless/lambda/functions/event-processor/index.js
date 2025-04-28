exports.handler = async (event, context) => {
  console.log('Event: ', JSON.stringify(event, null, 2));
  
  try {
    // Process the event (could be from SNS, SQS, DynamoDB, etc.)
    const records = event.Records || [];
    console.log(`Processing ${records.length} records`);
    
    // Example processing logic
    const processedItems = [];
    
    for (const record of records) {
      // Determine record type and process accordingly
      if (record.eventSource === 'aws:sqs') {
        // SQS record
        const body = JSON.parse(record.body);
        console.log('Processing SQS message:', body);
        processedItems.push({ id: record.messageId, status: 'processed' });
      } 
      else if (record.eventSource === 'aws:dynamodb') {
        // DynamoDB record
        const newImage = record.dynamodb.NewImage;
        console.log('Processing DynamoDB record:', newImage);
        processedItems.push({ id: record.eventID, status: 'processed' });
      }
      else if (record.EventSource === 'aws:sns') {
        // SNS record
        const message = JSON.parse(record.Sns.Message);
        console.log('Processing SNS message:', message);
        processedItems.push({ id: record.Sns.MessageId, status: 'processed' });
      }
      else {
        console.log('Unknown record type:', record);
        processedItems.push({ id: 'unknown', status: 'skipped' });
      }
    }
    
    console.log('Processed items:', processedItems);
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: `Successfully processed ${processedItems.length} items`,
        processedItems
      })
    };
  } catch (error) {
    console.error('Error: ', error);
    throw error; // Let Lambda handle the error
  }
};
