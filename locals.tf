locals {
    ## PLATFORM DEFAULTS
    #   These are platform specific configuration options. They should only need
    #       updated if the platform itself changes.   
    platform_defaults           = {
        enable_key_rotation     = true
        deletion_window_in_days = 10
    }
    
    ## CONDITIONS
    #   Configuration object containing boolean calculations that correspond
    #       to different deployment configurations.
    conditions                  = {
        root_principal          = var.kms.policy_principals == null
        merge                   = var.kms.additional_policies != null
    }

    ## CALCULATED PROPERTIES
    #   Variables that change based on the deployment configuration.
    policy                      = local.conditions.merge ? (
                                    data.aws_iam_policy_document.merged[0].json 
                                ) : ( 
                                    data.aws_iam_policy_document.unmerged.json 
                                )
    alias                       = join("-",[    
                                    "kms",
                                    module.platform.prefix,
                                    var.kms.alias_suffix
                                ])
    unmerged_policy_principals  = local.conditions.root_principal ? [
                                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
                                ] : var.kms.policy_principals
}