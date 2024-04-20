output "JenkinsDNS" {
  value = aws_instance.tf-jenkins-server.public_dns
}

output "JenkinsURL" {
  value = "http://${aws_instance.tf-jenkins-server.public_dns}:8080"
}