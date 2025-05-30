# 1. Configuring AWS account

provider "aws" {
    region = "ap-south-1"
    access_key = var.access_key
    secret_key = var.secret_key
}


# 2. Create a custom VPC

resource "aws_vpc" "first_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "Main-VPC"
    }
}

# 3. Create a Internet Gateway

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.first_vpc.id

    tags = {
        Name = "Main-InternetGateway"
    }
}

# 4. Create Custom Route Table

resource "aws_route_table" "first_route_table" {
    vpc_id = aws_vpc.first_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }


    

    route {
        ipv6_cidr_block = "::/0"
        gateway_id = aws_internet_gateway.gw.id
    }

}


# 5. Create a Subnet

resource "aws_subnet" "first_subnet" {
    vpc_id = aws_vpc.first_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
    tags = {
        Name = "main_subnet"
    }
}

# 6. Associate Subnet with route table

resource "aws_route_table_association" "subnet_route_table" {
    subnet_id = aws_subnet.first_subnet.id
    route_table_id = aws_route_table.first_route_table.id
}

# 7. Create Security Group to allow port 22, 80, 443

resource "aws_security_group" "first_security_group" {
    name = "allow_web_traffic"
    description = "allow web inbound traffic"
    vpc_id = aws_vpc.first_vpc.id

    ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

        ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

        ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow-web"
    }

}

# 8. Create a network interface with Ip in the subnet that was created in step 4

resource "aws_network_interface" "web-server-nic" {
    subnet_id       = aws_subnet.first_subnet.id
    private_ips     = ["10.0.1.50"]
    security_groups = [aws_security_group.first_security_group.id]
    
}

# 9. Assign an elastic Ip to the network interface created in step 8 

resource "aws_eip" "public_ip" {
    network_interface = aws_network_interface.web-server-nic.id
    domain = "vpc"
    associate_with_private_ip = "10.0.1.50"
    depends_on = [aws_internet_gateway.gw]
}

# 10. Create an Ubuntu Server and Install/enable Apache2

resource "aws_instance" "web-server-instance" {
    ami = "ami-00bb6a80f01f03502"
    instance_type = "t2.micro"
    availability_zone = "ap-south-1a"
    key_name = "MyNewKey"

    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.web-server-nic.id
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install -y nginx
                sudo systemctl start nginx
                sudo systemctl enable nginx
                echo "<h1>Welcome to Nginx web server</h1>" | sudo /var/www/html/index.html'
                EOF

    tags = {
        Name = "Web-server"
    }
}