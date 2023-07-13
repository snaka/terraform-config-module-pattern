module "config" {
  source = "../../modules/config"
}

resource "aws_vpc" "main" {
  cidr_block = module.config.v.vpc.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${module.config.prefix}-${module.config.env}"
  }
}

resource "aws_subnet" "public" {
  for_each = module.config.v.subnets.public

  vpc_id = aws_vpc.main.id
  availability_zone = each.key
  cidr_block = each.value

  tags = {
    Name = "${module.config.prefix}-${module.config.env}-public-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = module.config.v.subnets.private

  vpc_id = aws_vpc.main.id
  availability_zone = each.key
  cidr_block = each.value

  tags = {
    Name = "${module.config.prefix}-${module.config.env}-private-${each.key}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${module.config.prefix}-${module.config.env}"
  }
}

locals {
  nat_gateway_zones = toset(values(module.config.v.nat_gateway_zones))
}

resource "aws_eip" "natgw" {
  for_each = local.nat_gateway_zones

  vpc = true

  tags = {
    Name = "${module.config.prefix}-${module.config.env}-${each.key}"
  }
}

resource "aws_nat_gateway" "main" {
  for_each = local.nat_gateway_zones

  allocation_id = aws_eip.natgw[each.key].id
  subnet_id = aws_subnet.public[each.key].id

  tags = {
    Name = "${module.config.prefix}-${module.config.env}-${each.key}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${module.config.prefix}-${module.config.env}-public"
  }
}

resource "aws_route_table_association" "public" {
  for_each = module.config.v.subnets.public

  subnet_id = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  for_each = module.config.v.subnets.private

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[module.config.v.nat_gateway_zones[each.key]].id
  }

  tags = {
    Name = "${module.config.prefix}-${module.config.env}-private-${each.key}"
  }
}

resource "aws_route_table_association" "private" {
  for_each = module.config.v.subnets.private

  subnet_id = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}
