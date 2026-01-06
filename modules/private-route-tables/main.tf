# -------------------------
# Private Route Table
# -------------------------
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = merge(
    var.tags,
    {
      Name = "private-route-table"
    }
  )
}

# -------------------------
# Associate Route Table with Private Subnets
# -------------------------
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_ids)

  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private.id
}
