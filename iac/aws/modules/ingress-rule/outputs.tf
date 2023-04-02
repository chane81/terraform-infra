output "alb_host" {
  description = "alb hosts"
  value       = resource.kubernetes_ingress_v1.apps_ingress.status[0].load_balancer[0].ingress[0].hostname
}

output "alb_arn" {
  description = "alb arn"
  value       = one(data.aws_lbs.alb.arns)
}
