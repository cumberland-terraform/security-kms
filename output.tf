output "key" {
    description     = "Metadata of the KMS Key that has been provisioned"
    value           = {
        id          = aws_kms_key.this.key_id
        arn         = aws_kms_key.this.arn
        alias_arn   = aws_kms_alias.this.arn
    }
}