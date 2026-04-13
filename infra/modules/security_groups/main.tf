resource "aws_security_group" "alb" {
   name        = "${var.project_name}-alb-sg"
   description = "security group for alb"
   vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.alb_ingress_rules
    content {
      description = "allow hhtp and https traffic from internet"  
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
      description = "allow all outbound traffic"  
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }    

   tags = merge(var.tags, {
    Name = "${var.project_name}-alb-sg"
  })
}

resource "aws_security_group" "ecs" {
   name        = "${var.project_name}-ecs-sg"
   description = "security group for ecs"
   vpc_id      = var.vpc_id

  ingress {
      description     = "allow traffic from alb"  
      from_port       = var.container_port
      to_port         = var.container_port
      protocol        = "tcp"
      security_groups = [aws_security_group.alb.id]
    }

  egress {
      description = "allow all outbound traffic"  
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }  

   tags = merge(var.tags, {
    Name = "${var.project_name}-ecs-sg"
  })
}