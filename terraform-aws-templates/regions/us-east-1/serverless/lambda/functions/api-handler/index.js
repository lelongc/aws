exports.handler = async (event, context) => {
  console.log('Event: ', JSON.stringify(event, null, 2));
  
  try {
    // Process the API Gateway event
    const path = event.path;
    const method = event.httpMethod;
    const headers = event.headers;
    const queryStringParameters = event.queryStringParameters || {};
    const body = event.body ? JSON.parse(event.body) : {};
    
    console.log(`Received ${method} request on ${path}`);
    
    // Example response
    let response = {
      message: 'Hello from Lambda',
      path,
      method,
      timestamp: new Date().toISOString()
    };
    
    // Return a successful response
    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*' // For CORS
      },
      body: JSON.stringify(response)
    };
  } catch (error) {
    console.error('Error: ', error);
    
    // Return an error response
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        message: 'Internal Server Error',
        error: error.message
      })
    };
  }
};
