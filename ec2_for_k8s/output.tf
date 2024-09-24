output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://${aws_instance.jenkins_server.public_ip}:8080"
}


output "instance_public_ip" {
  description = "Public IP of the Jenkins server"
  value       = aws_instance.jenkins_server.public_ip
}
