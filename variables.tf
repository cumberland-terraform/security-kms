variable "platform" {
  description               = "Platform metadata object."
  type                      = object({
    client                  = string
    environment             = string
  })

}


variable "kms" {
    description             = "KMS Key configuration. Policy should be JSON string, and is applied in addition to the default KMS policy. `alias_suffix` is added to the key alias after the platform prefixes. `policy_principals` is a list of IAM principal ARNs to add to the access policy for the KMS key. If no `policy_principals` are provided, access will be given to all IAM principals in the agency program's account. `additional_policys` is a list of stringified policy JSONs, to be appended in addition to the baseline KMS key policy."
    type                    = object({
      alias_suffix          = string
      description           = optional(string, null)
      policy_principals     = optional(list(string), null)
      additional_policies   = optional(list(string), null)
    })
}