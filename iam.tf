## IAM Role and Policy ###
## Allows Lambda Function to Describe, stop and start EC2 Instances

resource "aws_iam_role" "ec2_iam_role" {
  name               = "ec2_start_stop_schedular"
  assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com",
                "Service": "kms.amazonaws.com"

            },
            "Effect": "Allow",
            "Sid": ""
            }
          ]
    }
EOF  
}


data "aws_iam_policy_document" "ec2_start_stop_schedular" {
  statement {

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }

  statement {
    actions = [
      "ec2:Describe*",
      "ec2:Stop*",
      "ec2:Start*"
    ]
    resources = ["*", ]
  }

  statement {

       actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = ["arn:aws:kms:*:*:*", ]
  }

  statement {
    actions = [
        "kms:RevokeGrant",
        "kms:CreateGrant",
        "kms:ListGrants"
    ]
    resources = ["*",]
    condition {
        test     = "Bool"
        variable = "kms:GrantIsForAWSResource"
        values   = [true]
    }
  }

}

resource "aws_iam_policy" "ec2_start_stop_schedular" {
  name   = "ec2_access_schedular"
  path   = "/"
  policy = data.aws_iam_policy_document.ec2_start_stop_schedular.json

}

resource "aws_iam_policy_attachment" "ec2_access_schedular" {
  name       = "iam_policy_attachment"
  roles      = [aws_iam_role.ec2_iam_role.name]
  policy_arn = aws_iam_policy.ec2_start_stop_schedular.arn

}
