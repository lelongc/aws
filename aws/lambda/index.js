const AWS = require("aws-sdk");
const dynamoDB = new AWS.DynamoDB.DocumentClient();
const s3 = new AWS.S3();
const sns = new AWS.SNS();

// Environment variables
const TABLE_NAME = process.env.TABLE_NAME;
const BUCKET_NAME = process.env.BUCKET_NAME;
const SNS_TOPIC_ARN = process.env.SNS_TOPIC_ARN;

exports.handler = async (event) => {
  console.log("Event received:", JSON.stringify(event, null, 2));

  try {
    // Check event source
    if (event.Records && event.Records[0].eventSource === "aws:s3") {
      // Handle S3 event
      return await handleS3Event(event);
    } else if (
      event.Records &&
      event.Records[0].eventSource === "aws:dynamodb"
    ) {
      // Handle DynamoDB stream event
      return await handleDynamoDBEvent(event);
    } else if (event.httpMethod) {
      // Handle API Gateway event
      return await handleAPIEvent(event);
    } else {
      // Handle direct invocation
      return await handleDirectEvent(event);
    }
  } catch (error) {
    console.error("Error processing event:", error);

    // Send error notification
    await sendErrorNotification(error, event);

    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Internal server error" }),
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
    };
  }
};

async function handleS3Event(event) {
  const bucket = event.Records[0].s3.bucket.name;
  const key = decodeURIComponent(
    event.Records[0].s3.object.key.replace(/\+/g, " ")
  );

  console.log(`Processing new file: ${bucket}/${key}`);

  // Get file metadata
  const metadata = await s3
    .headObject({
      Bucket: bucket,
      Key: key,
    })
    .promise();

  // Save metadata to DynamoDB
  await dynamoDB
    .put({
      TableName: TABLE_NAME,
      Item: {
        id: key,
        type: "file",
        bucket: bucket,
        size: metadata.ContentLength,
        contentType: metadata.ContentType,
        lastModified: metadata.LastModified.toISOString(),
        createdAt: new Date().toISOString(),
      },
    })
    .promise();

  return {
    statusCode: 200,
    body: JSON.stringify({ message: "File processed successfully" }),
  };
}

async function handleDynamoDBEvent(event) {
  const processedItems = [];

  for (const record of event.Records) {
    if (record.eventName === "INSERT" || record.eventName === "MODIFY") {
      const newItem = AWS.DynamoDB.Converter.unmarshall(
        record.dynamodb.NewImage
      );

      // Process item
      console.log(`Processing DynamoDB item: ${JSON.stringify(newItem)}`);
      processedItems.push(newItem);

      // Notify about the change
      await sns
        .publish({
          TopicArn: SNS_TOPIC_ARN,
          Message: JSON.stringify({
            eventType: record.eventName,
            item: newItem,
          }),
          Subject: `DynamoDB ${record.eventName} Event`,
        })
        .promise();
    }
  }

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "DynamoDB events processed",
      processedItems: processedItems.length,
    }),
  };
}

async function handleAPIEvent(event) {
  // Get path and method
  const path = event.path;
  const method = event.httpMethod;

  console.log(`API request: ${method} ${path}`);

  if (method === "GET" && path === "/items") {
    // List all items
    const result = await dynamoDB
      .scan({
        TableName: TABLE_NAME,
      })
      .promise();

    return {
      statusCode: 200,
      body: JSON.stringify(result.Items),
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
    };
  }

  if (method === "GET" && path.startsWith("/items/")) {
    // Get specific item
    const id = path.split("/").pop();

    const result = await dynamoDB
      .get({
        TableName: TABLE_NAME,
        Key: { id },
      })
      .promise();

    if (result.Item) {
      return {
        statusCode: 200,
        body: JSON.stringify(result.Item),
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
      };
    } else {
      return {
        statusCode: 404,
        body: JSON.stringify({ message: "Item not found" }),
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
      };
    }
  }

  if (method === "POST" && path === "/items") {
    // Create new item
    const body = JSON.parse(event.body);
    const item = {
      id: body.id || Date.now().toString(),
      ...body,
      createdAt: new Date().toISOString(),
    };

    await dynamoDB
      .put({
        TableName: TABLE_NAME,
        Item: item,
      })
      .promise();

    return {
      statusCode: 201,
      body: JSON.stringify(item),
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
    };
  }

  // Method not allowed
  return {
    statusCode: 405,
    body: JSON.stringify({ message: "Method not allowed" }),
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      Allow: "GET, POST",
    },
  };
}

async function handleDirectEvent(event) {
  // Process custom event
  console.log("Processing direct invocation with payload:", event);

  // Example: Save event data
  if (event.action === "save") {
    const item = {
      id: event.id || Date.now().toString(),
      type: "custom",
      data: event.data,
      createdAt: new Date().toISOString(),
    };

    await dynamoDB
      .put({
        TableName: TABLE_NAME,
        Item: item,
      })
      .promise();

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Data saved successfully",
        id: item.id,
      }),
    };
  }

  return {
    statusCode: 400,
    body: JSON.stringify({ message: "Invalid action" }),
  };
}

async function sendErrorNotification(error, event) {
  try {
    await sns
      .publish({
        TopicArn: SNS_TOPIC_ARN,
        Message: JSON.stringify({
          error: {
            message: error.message,
            stack: error.stack,
          },
          event: event,
        }),
        Subject: "Lambda Function Error",
      })
      .promise();
  } catch (snsError) {
    console.error("Failed to send error notification:", snsError);
  }
}
