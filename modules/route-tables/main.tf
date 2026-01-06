# -------------------------
# Public Route Table
# -------------------------
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = merge(
    var.tags,
    {
      Name = "public-route-table"
    }
  )
}

# -------------------------
# Associate Route Table with Public Subnets
# -------------------------
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_ids)

  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}
