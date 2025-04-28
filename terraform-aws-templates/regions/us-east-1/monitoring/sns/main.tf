provider "aws" {
  region = var.region
}

# SNS Topics
resource "aws_sns_topic" "topics" {
  for_each = { for topic in var.topics : topic.name => topic }
  
  name         = "${var.project}-${var.environment}-${each.value.name}"
  display_name = lookup(each.value, "display_name", "${var.project}-${var.environment}-${each.value.name}")
  
  kms_master_key_id = lookup(each.value, "kms_master_key_id", null)
  
  fifo_topic                  = lookup(each.value, "fifo_topic", false)
  content_based_deduplication = lookup(each.value, "content_based_deduplication", false)
  
  delivery_policy = lookup(each.value, "delivery_policy", null)
  
  tags = merge(
    {
      Name        = "${var.project}-${var.environment}-${each.value.name}"
      Environment = var.environment
      Project     = var.project
      Terraform   = "true"
    },
    lookup(each.value, "tags", {})
  )
}

# SNS Topic Subscriptions
resource "aws_sns_topic_subscription" "subscriptions" {
  for_each = { 
    for idx, sub in var.subscriptions : 
    "${sub.topic_name}-${sub.protocol}-${idx}" => sub 
  }
  
  topic_arn     = aws_sns_topic.topics[each.value.topic_name].arn
  protocol      = each.value.protocol
  endpoint      = each.value.endpoint
  filter_policy = lookup(each.value, "filter_policy", null)
  
  endpoint_auto_confirms    = lookup(each.value, "endpoint_auto_confirms", false)
  confirmation_timeout_in_minutes = lookup(each.value, "confirmation_timeout_in_minutes", null)
  
  delivery_policy = lookup(each.value, "delivery_policy", null)
  
  raw_message_delivery = lookup(each.value, "raw_message_delivery", false)
}

# SNS Topic Policy (for public access or cross-account)
resource "aws_sns_topic_policy" "policies" {
  for_each = { for topic in var.topics : topic.name => topic if lookup(topic, "policy", null) != null }
  
  arn    = aws_sns_topic.topics[each.key].arn
  policy = each.value.policy
}
