resource "aws_kms_key" "this" {
  lifecycle {
    ignore_changes          = [ tags  ]
  }
  
  description               = var.kms.description
  deletion_window_in_days   = local.platform_defaults.deletion_window_in_days
  enable_key_rotation       = local.platform_defaults.enable_key_rotation
  policy                    = local.policy
  tags                      = module.platform.tags
}

resource "aws_kms_alias" "this" {
  name                      = "alias/${local.alias}"
  target_key_id             = aws_kms_key.this.key_id
}