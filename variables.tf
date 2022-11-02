
variable "name" {
  description = "Name of the GKE deployment"
  type        = string
}

variable "project" {
  description = "Project where the GKE gets deployed"
  type        = string
}

variable "region" {
  description = "Region where the GKE gets deployed"
  type        = string
}

variable "enable_vertical_pod_autoscaling" {
  type    = bool
  default = true
}

variable "filestore_csi_driver" {
  type    = bool
  default = true
}

variable "common_tags" {
  type = map(list(string))
  default = {
    all               = [],
    default-node-pool = []
  }
}

variable "subnet_private_access" {
  type    = bool
  default = true
}

variable "subnet_flow_logs" {
  type    = bool
  default = true
}

variable "cluster_autoscaling" {
  type = object({
    enabled       = bool
    min_cpu_cores = number
    max_cpu_cores = number
    min_memory_gb = number
    max_memory_gb = number
    gpu_resources = list(object({ resource_type = string, minimum = number, maximum = number }))
  })
  default = {
    enabled       = true
    max_cpu_cores = 12
    min_cpu_cores = 2
    max_memory_gb = 48
    min_memory_gb = 4
    gpu_resources = []
  }
  description = "Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling)"
}


variable "machine_type" {
  type    = string
  default = null
}

variable "disk_size_gb" {
  type    = number
  default = 120
}

variable "min_count" {
  type    = number
  default = 3
}

variable "max_count" {
  type    = number
  default = 10
}
