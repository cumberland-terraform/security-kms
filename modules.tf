module "platform" {
  source                = "github.com/cumberland-terraform/platform"

  platform              = var.platform
  
  hydration             = {
    vpc_query           = false
    subnets_query       = false
    dmem_sg_query       = false
    rhel_sg_query       = false
    eks_ami_query       = false
  }
}
