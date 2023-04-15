output "alb_host" {
  description = "alb hosts"
  value       = data.kubernetes_ingress_v1.ingress.status.0.load_balancer.0.ingress.0.hostname
}

output "alb_arn" {
  description = "alb arn"
  value       = one(data.aws_lbs.alb.arns)
}
