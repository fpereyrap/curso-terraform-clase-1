#outputs
output "private_key"{
    value = tls_private_key.example.private_key_pem
}

output "public_ip"{
    value = aws_instance.web.public_ip
}