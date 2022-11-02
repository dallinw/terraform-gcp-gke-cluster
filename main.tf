data "google_compute_zones" "available" {
}


## https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest
module "kubernetes-engine" {
  source     = "terraform-google-modules/kubernetes-engine/google"
  version    = "23.2.0"
  depends_on = [module.gke_network]

  project_id = var.project
  name       = var.name
  region     = var.region
  regional   = true

  # Network
  network           = var.name
  subnetwork        = "${var.name}-node-pool-subnet"
  ip_range_pods     = "${var.name}-subnet-gke-pods-1"
  ip_range_services = "${var.name}-subnet-gke-services-1"

  # Policy
  network_policy          = true
  network_policy_provider = "CALICO"

  # Features
  enable_vertical_pod_autoscaling = var.enable_vertical_pod_autoscaling
  filestore_csi_driver            = var.filestore_csi_driver

  # Access
  grant_registry_access = true

  cluster_autoscaling = var.cluster_autoscaling

  node_pools_tags = var.common_tags

  # We suggest removing the default node pool, as it cannot be modified without
  # destroying the cluster.
  remove_default_node_pool = true

  initial_node_count = 1

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = var.machine_type
      min_count          = var.min_count
      max_count          = var.max_count
      disk_size_gb       = var.disk_size_gb
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = true
      enable_gvnic       = true
    },
  ]
}

module "gke_network" {
  source  = "terraform-google-modules/network/google"
  version = ">= 4.0.1, < 5.0.0"

  project_id   = var.project
  network_name = var.name

  subnets = [
    {
      subnet_name           = "${var.name}-node-pool-subnet"
      subnet_ip             = "10.0.0.0/24"
      subnet_region         = var.region
      subnet_private_access = var.subnet_private_access
      subnet_flow_logs      = var.subnet_flow_logs
    },
  ]

  secondary_ranges = {
    "${var.name}-node-pool-subnet" = [
      {
        range_name    = "${var.name}-subnet-gke-pods-1"
        ip_cidr_range = "10.10.0.0/16"
      },
      {
        range_name    = "${var.name}-subnet-gke-services-1"
        ip_cidr_range = "10.20.0.0/20"
      },
  ] }
}
