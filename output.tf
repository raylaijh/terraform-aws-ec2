# Outputs file
output "ec2_pub_url" {
  value = "http://${aws_eip.foo.public_dns}"
}

output "ec2_pub_ip" {
  value = "http://${aws_eip.foo.public_ip}"
}
