provider "google" { 
  # Provide your GCP Creadentilals 
  credentials = "${file("xyz.json")}"

  # The name of your GCP project 
  project = "xyz-12345"
}

module "yugabyte-db-cluster" {
//source = "github.com/YugaByte/terraform-gcp-yugabyte.git"
source = "github.com/vp15591/terraform-gcp-yugabyte/tree/bug-fix"
# The name of the cluster to be created.
cluster_name = "test-yugabyte-k3s"

 # Path to key pair for the host machine.
ssh_private_key ="id_rsa"
ssh_public_key = "id_rsa.pub"
ssh_user = "user"

# The region name where the nodes should be spawned.
region_name = "us-east1"

# Replication factor.
replication_factor = "3"

# The number of nodes in the cluster, this cannot be lower than the replication factor.
node_count = "3"
}
