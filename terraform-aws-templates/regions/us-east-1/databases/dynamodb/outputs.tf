output "table_arns" {
  description = "ARNs of the DynamoDB tables"
  value       = { for name, table in aws_dynamodb_table.this : name => table.arn }
}

output "table_ids" {
  description = "IDs of the DynamoDB tables"
  value       = { for name, table in aws_dynamodb_table.this : name => table.id }
}

output "table_names" {
  description = "Names of the DynamoDB tables"
  value       = { for name, table in aws_dynamodb_table.this : name => table.name }
}

output "table_stream_arns" {
  description = "Stream ARNs of the DynamoDB tables"
  value       = { for name, table in aws_dynamodb_table.this : name => table.stream_arn if table.stream_enabled }
}

output "table_stream_labels" {
  description = "Stream labels of the DynamoDB tables"
  value       = { for name, table in aws_dynamodb_table.this : name => table.stream_label if table.stream_enabled }
}
