variable "prod_vm_memory" {
  description = "Quantité de RAM pour chaque VM de la prod"
  type        = string
  default     = "1024 mib"
}

variable "prod_vm_cpus" {
  description = "Nombre de processeurs par VM de la prod"
  type        = number
  default     = 1
}

variable "staging_vm_memory" {
  description = "Quantité de RAM pour chaque VM du staging"
  type        = string
  default     = "1024 mib"
}

variable "staging_vm_cpus" {
  description = "Nombre de processeurs par VM du staging"
  type        = number
  default     = 1
}

variable "image_url" {
  description = "L'URL de l'image Vagrant/VirtualBox à télécharger"
  type        = string
  default     = "https://app.vagrantup.com/bento/boxes/ubuntu-22.04/versions/202309.08.0/providers/virtualbox.box"
}