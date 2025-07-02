
output "deployment_name" {
    description = "Nombre del Deployment Kubernetes"
    value       = kubernetes_deployment.app.metadata[0].name
}

output "deployment_replicas" {
    description = "Número de réplicas del Deployment"
    value       = tonumber(kubernetes_deployment.app.spec[0].replicas)
}

output "container_image" {
    description = "Imagen usada en el contenedor del Deployment"
    value       = kubernetes_deployment.app.spec[0].template[0].spec[0].container[0].image
}

output "container_port" {
    description = "Puerto expuesto por el contenedor del Deployment"
    value       = tonumber(kubernetes_deployment.app.spec[0].template[0].spec[0].container[0].port[0].container_port)
}

output "service_name" {
    description = "Nombre del Service Kubernetes"
    value       = kubernetes_service.app.metadata[0].name
}

output "service_port" {
    description = "Puerto configurado en el Service"
    value       = tonumber(kubernetes_service.app.spec[0].port[0].port)
}

output "service_target_port" {
    description = "Target port configurado en el Service"
    value       = tonumber(kubernetes_service.app.spec[0].port[0].target_port)
}

output "service_type" {
    description = "Tipo de Service (ClusterIP, NodePort, etc.)"
    value       = kubernetes_service.app.spec[0].type
}

output "service_cluster_ip" {
    description = "Cluster IP asignada al Service"
    value       = kubernetes_service.app.spec[0].cluster_ip
}
