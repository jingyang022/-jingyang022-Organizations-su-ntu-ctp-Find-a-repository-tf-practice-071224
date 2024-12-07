resource "aws_iam_role" "ec2_role_terraform" {
  name = "yap-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "rds_attachment" {
  name       = "example-attachment"
  roles      = [aws_iam_role.ec2_role_terraform.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "yap_ec2_profile"
  role = aws_iam_role.ec2_role_terraform.name
}