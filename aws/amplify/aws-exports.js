const awsmobile = {
  aws_project_region: "ap-southeast-1",
  aws_cognito_identity_pool_id:
    "ap-southeast-1:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  aws_cognito_region: "ap-southeast-1",
  aws_user_pools_id: "ap-southeast-1_xxxxxxxxx",
  aws_user_pools_web_client_id: "xxxxxxxxxxxxxxxxxxxxxxxxxx",
  oauth: {},
  aws_appsync_graphqlEndpoint:
    "https://xxxxxxxxxxxxxxxxxxxxxxxx.appsync-api.ap-southeast-1.amazonaws.com/graphql",
  aws_appsync_region: "ap-southeast-1",
  aws_appsync_authenticationType: "AMAZON_COGNITO_USER_POOLS",
  aws_cloud_logic_custom: [
    {
      name: "api",
      endpoint:
        "https://xxxxxxxxxx.execute-api.ap-southeast-1.amazonaws.com/dev",
      region: "ap-southeast-1",
    },
  ],
  aws_user_files_s3_bucket: "user-uploads-xxxxxxxx-dev",
  aws_user_files_s3_bucket_region: "ap-southeast-1",
  aws_content_delivery_bucket: "content-delivery-xxxxxxxx-dev",
  aws_content_delivery_bucket_region: "ap-southeast-1",
  aws_content_delivery_url: "https://xxxxxxxxxx.cloudfront.net",
  aws_dynamodb_all_tables_region: "ap-southeast-1",
  aws_dynamodb_table_schemas: [
    {
      tableName: "dev-user-table",
      region: "ap-southeast-1",
    },
  ],
};

export default awsmobile;
