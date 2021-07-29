resource aws_sqs_queue queue {

  name = var.service_name

  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  max_message_size           = var.max_message_size
  delay_seconds              = var.delay_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn,
    maxReceiveCount     = var.max_receive_count
  })
  policy = var.policy

  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
}

resource aws_sqs_queue dlq {
  name                      = "${var.service_name}-dlq"
  message_retention_seconds = var.message_retention_seconds
}
