output "private_ip" {
description = "List of private IP addresses assigned to the instances"
value       = aws_instance.moreira-redis.private_ip
}

output "public_ip" {
description = "List of public IP addresses assigned to the instances"
value       = aws_instance.moreira-redis.public_ip    
}