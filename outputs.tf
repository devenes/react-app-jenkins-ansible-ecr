output "managed_node_public_ip" {
  value = aws_instance.managed_node.*.public_ip
}

output "managed_node_private_ip" {
  value = aws_instance.managed_node.*.private_ip
}

output "managed_node_tags" {
  value = aws_instance.managed_node.*.tags
}

output "react_ip" {
  value = "http://${aws_instance.managed_node[2].public_ip}:3000"
}

output "node_public_ip" {
  value = aws_instance.managed_node[1].public_ip
}

output "postgre_private_ip" {
  value = aws_instance.managed_node[0].private_ip
}
