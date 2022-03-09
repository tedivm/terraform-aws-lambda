
resource "aws_security_group" "main" {
  count       = var.enable_networking ? 1 : 0
  name        = var.name
  description = "Grants egress to the function."
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge({
    name = var.name
  }, var.tags)
}
