resource "aws_instance" "public" {
    ami = "ami-04c913012f8977029"
    instance_type = "t2.micro"
    subnet_id = data.aws_subnets.public.ids[0] #Public Subnet ID, e.g. subnet-xxxxxxxxxxx
    associate_public_ip_address = true
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
    #key_name = "yap-231124" #Change to your keyname, e.g. jazeel-key-pair
    vpc_security_group_ids = [aws_security_group.example.id]

    tags = {
        Name = "${var.name}-ec2-RDS"
        }
}