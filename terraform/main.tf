terraform {
	required_providers {
			virtualbox = {
			source = "terra-farm/virtualbox"
			version = "0.2.2-alpha.1"
		}
	}
}

# STAGING

resource "virtualbox_vm" "tf_staging_web" {
	name      = "tf-staging-web"
	image     = var.image_url
	cpus      = var.staging_vm_cpus
	memory    = var.staging_vm_memory

	network_adapter {
		type = "nat"
	}
	
	network_adapter {
		type           = "hostonly"
        host_interface = "vboxnet0"
	}
}

resource "local_file" "ansible_inventory" {
  content = <<EOF
[staging]
tf-staging-web ansible_host=${virtualbox_vm.tf_staging_web.network_adapter[0].ipv4_address} ansible_user=vagrant ansible_ssh_pass=vagrant

[webservers]
tf-staging-web
EOF

  filename = "inventory.ini" 
}

# resource "virtualbox_vm" "tf_staging_db" {
# 	name      = "tf-staging-db"
# 	image     = var.image_url
# 	cpus      = var.staging_vm_cpus
# 	memory    = var.staging_vm_memory

# 	network_adapter {
# 		type           = "bridged"
#     	host_interface = "wlp0s20f3"
# 	}

# 	user_data = templatefile("${path.module}/network.tftpl", {
#     	ip_address = "192.168.0.203"
#   })
# }

# # PRODUCTION

# resource "virtualbox_vm" "tf_prod_web" {
# 	name      = "tf-prod-web"
# 	image     = var.image_url
# 	cpus      = var.prod_vm_cpus
# 	memory    = var.prod_vm_memory

# 	network_adapter {
# 		type           = "bridged"
#     	host_interface = "wlp0s20f3"
# 	}	

# 	user_data = templatefile("${path.module}/network.tftpl", {
#     	ip_address = "192.168.0.204"
#   })
# }

# resource "virtualbox_vm" "tf_prod_db" {
# 	name      = "tf-prod-db"
# 	image     = var.image_url
# 	cpus      = var.prod_vm_cpus
# 	memory    = var.prod_vm_memory

# 	network_adapter {
# 		type           = "bridged"
#     	host_interface = "wlp0s20f3"
# 	}

# 	user_data = templatefile("${path.module}/network.tftpl", {
#     	ip_address = "192.168.0.205"
#   })
# }