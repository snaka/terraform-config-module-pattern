output "vpc" {
  value = {
    id = aws_vpc.main.id
    cidr = aws_vpc.main.cidr_block
    subnets = {
      public = values(aws_subnet.public)[*].id
      private = values(aws_subnet.private)[*].id
    }
  }
}
