output "webserver_public_ip" {
  value = [for i in range(var.server_count): aws_instance.web_server[i].public_ip]
}

output "webserver_public_dns" {
  value = [for i in range(var.server_count): aws_instance.web_server[i].public_dns]
}

output "webserver_private_dns" {
  value = [for i in range(var.server_count): aws_instance.web_server[i].private_dns]
}

output "webserver_private_ip" {
  value = [for i in range(var.server_count): aws_instance.web_server[i].private_ip]
}

output "security_group_id" {
  value = aws_security_group.webserver_sg.id
}