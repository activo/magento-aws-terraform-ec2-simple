
output "web1_dns_name" {
  value = "${aws_instance.web1.public_dns}"
}

output "web1_ip" {
  value = "${aws_instance.web1.public_ip}"
}

output "web_instance_id" {
  value = "${aws_instance.web1.id}"
}

output "web_security_group" {
  value = "${aws_security_group.default-web.id}"
}