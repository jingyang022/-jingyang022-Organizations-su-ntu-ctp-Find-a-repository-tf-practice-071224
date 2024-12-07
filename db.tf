resource "aws_db_subnet_group" "yap_db_subnet" {
  name       = "yap_db_subnet"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    Name = "yap_db_subnet"
  }
}

resource "aws_db_instance" "default" {
    identifier                  = "yap-database"
    allocated_storage           = 10
    db_name                     = "yapDB"
    engine                      = "mysql"
    engine_version              = "8.0"
    instance_class              = "db.t3.micro"
    db_subnet_group_name        = aws_db_subnet_group.yap_db_subnet.name
    manage_master_user_password = true
    username                    = "admin"
    parameter_group_name        = "default.mysql8.0"
    skip_final_snapshot         = true
}