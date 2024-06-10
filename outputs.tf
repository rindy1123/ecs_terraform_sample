output "rds_hostname" {
  description = "RDS instance hostname"
  value       = module.rds.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.rds.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = module.rds.username
  sensitive   = true
}

output "endpoint" {
  value = module.ecs.endpoint
}
