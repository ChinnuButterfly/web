
# creating vpc on the aws 
resource "aws_vpc" "webapp_vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_hostnames = true

}

# creating subents and attching to the created vpc 

resource "aws_subnet" "subnet1" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.webapp_vpc.id
    map_public_ip_on_launch = true
  
}

# create security group and route the traffic on internet 

resource "aws_security_group" "security_group" {

    name =  "security_group"
    vpc_id = aws_vpc.webapp_vpc.id

    ingress =  [ {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "HTTPS"
      from_port = 443
      ipv6_cidr_blocks = [ "::/0" ]
      protocol = "tcp"
      to_port = 443
      prefix_list_ids = []
      security_groups = []
      self = false
    } ,
    {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "HTTP"
      from_port = 80
      ipv6_cidr_blocks = [ "::/0" ]
      protocol = "tcp"
      to_port = 80
      prefix_list_ids = []
      security_groups = []
      self = false
    }  ]

    egress = [ {
        description = "For all outgoing traffic"
        from_port = 0 
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = [ "::/0" ]
        prefix_list_ids = []
      security_groups = []
      self = false
    }]
}
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.webapp_vpc.id
  
}

resource "aws_route_table" "rt" {

  vpc_id =  aws_vpc.webapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.ig.id
  }
  
}

resource "aws_route_table_association" "route" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.subnet1.id
}
