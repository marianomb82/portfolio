# Definición de las variables

# ID proyecto,región y zona
variable "project_id" {
  description = "GCloud Project ID"
}

variable "region" {
  description = "GCloud Region"
}

variable "zone" {
  description = "GCloud zone"
}

variable "gke_num_nodes" {
  #  default     = 2
  description = "Number of gke nodes"
}

#Para introducir valores distintos en el despliegue, se llama a la variable : terraform apply -var initial_node_count=3