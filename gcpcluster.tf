provider "google" { 
  # Provide your GCP Creadentilals 
  credentials = "${file("omni-163105-205924bf2b1f.json")}"

  # The name of your GCP project 
  project = "omni-163105"
}

module "yugabyte-db-cluster" {
source = "github.com/YugaByte/terraform-gcp-yugabyte.git"
# The name of the cluster to be created.
cluster_name = "test-yugabyte-k3s"

 # key pair.
ssh_private_key ="id_rsa"
ssh_public_key = "id_rsa.pub"
ssh_user = "manish"

# The region name where the nodes should be spawned.
region_name = "us-east1"

# Replication factor.
replication_factor = "1"

# The number of nodes in the cluster, this cannot be lower than the replication factor.
node_count = "1"
}
