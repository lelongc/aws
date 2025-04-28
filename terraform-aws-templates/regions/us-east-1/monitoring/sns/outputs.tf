output "topic_arns" {
  description = "Map of topic names to ARNs"
  value = {
    for name, topic in aws_sns_topic.topics : name => topic.arn
  }
}

output "topic_ids" {
  description = "Map of topic names to IDs"
  value = {
    for name, topic in aws_sns_topic.topics : name => topic.id
  }
}

output "subscription_arns" {
  description = "Map of subscription keys to ARNs"
  value = {
    for key, subscription in aws_sns_topic_subscription.subscriptions : key => subscription.arn
  }
}

output "subscription_ids" {
  description = "Map of subscription keys to IDs"
  value = {
    for key, subscription in aws_sns_topic_subscription.subscriptions : key => subscription.id
  }
}
