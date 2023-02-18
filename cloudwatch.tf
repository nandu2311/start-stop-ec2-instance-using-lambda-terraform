## CloudWatch Event
#Event rule: Runs at 8am during working days start instance
resource "aws_cloudwatch_event_rule" "start_instance_event_rule" {
  name        = "start-instance-event-rule"
  description = "Starts Stopped EC2 Instance"
  #schedule_expression = "cron(0 8 ? * MON-FRI *)"
  /* schedule_expression = "cron(0/10 * ? * MON-FRI *)" */
  schedule_expression = "rate(5 minutes)"
  depends_on = [ aws_lambda_function.ec2_start_schedular_lambda ] #Mention here start lambda function

}

# Events at 8pm during Working Days stop instance
resource "aws_cloudwatch_event_rule" "stop_instance_event_rule" {
  name        = "stop-instance-event-rule"
  description = "Stop Running EC2 Instances"
  /* schedule_expression = "cron(0 20 ? * MON-FRI *)" */
  /* schedule_expression = "cron(0/5 * ? * MON-FRI *)" */
  schedule_expression = "rate(2 minutes)"
  depends_on = [
    aws_lambda_function.ec2_stop_schedular_lambda
  ] # Mention here stop lambda function

}

# Event Target: Associate a rule with a Function to run start function
resource "aws_cloudwatch_event_target" "start_instance_event_target" {
  target_id = "start_instance_lambda_target"
  rule      = aws_cloudwatch_event_rule.start_instance_event_rule.name
  arn       = aws_lambda_function.ec2_start_schedular_lambda.arn
}

resource "aws_cloudwatch_event_target" "stop_instance_event_target" {
  target_id = "stop_instance_lambda_target"
  rule      = aws_cloudwatch_event_rule.stop_instance_event_rule.name
  arn       = aws_lambda_function.ec2_stop_schedular_lambda.arn
}

## AWS Lambda Permission: Allow Cloudwatch to execute the Lambda functions
resource "aws_lambda_permission" "allow_cloudwatch_to_call_start_schedular" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_start_schedular_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_instance_event_rule.arn

}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_stop_schedular" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_stop_schedular_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_instance_event_rule.arn
}

