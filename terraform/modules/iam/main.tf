resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = { for p in var.policies : p => p }
  role       = aws_iam_role.this.name
  policy_arn = each.value
}
