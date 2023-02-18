## AWS Lambda Function ##
## AWS Lambda API Requires a ZIP Files with the execution code
data "archive_file" "start_schedular" {
  type        = "zip"
  source_file = "start_instance.py"
  output_path = "start_instance.zip"

}

data "archive_file" "stop_schedular" {
  type        = "zip"
  source_file = "stop_instance.py"
  output_path = "stop_instance.zip"

}

### Lambda defined that runs the Python Code with the specified IAM Role
resource "aws_lambda_function" "ec2_start_schedular_lambda" {
  filename         = data.archive_file.start_schedular.output_path
  function_name    = "start_instances"
  role             = aws_iam_role.ec2_iam_role.arn
  handler          = "start_instance.lambda_handler"
  runtime          = "python3.9"
  timeout          = 300
  source_code_hash = data.archive_file.start_schedular.output_base64sha256
}

resource "aws_lambda_function" "ec2_stop_schedular_lambda" {
  filename         = data.archive_file.stop_schedular.output_path
  function_name    = "stop_instances"
  role             = aws_iam_role.ec2_iam_role.arn
  handler          = "stop_instance.lambda_handler"
  runtime          = "python3.9"
  timeout          = 300
  source_code_hash = data.archive_file.stop_schedular.output_base64sha256

}