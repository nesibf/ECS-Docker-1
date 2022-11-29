
resource "aws_ecs_task_definition" "task" {
  family                   = "task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "${data.aws_iam_role.ecs-task.arn}"

  container_definitions = jsonencode([
    {
      name   = "act1-container"
      image  = "875525659788.dkr.ecr.us-east-1.amazonaws.com/service1:latest" 
      cpu    = 256
      memory = 512
      portMappings = [
        {
          containerPort = 80
          
        }
      ]
    }
  ])
}





resource "aws_ecs_service" "svc" {
  name            = "act1-Service"
  cluster         = "${aws_ecs_cluster.ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.task.id}"
  desired_count   = 2
  launch_type     = "FARGATE"


  network_configuration {
    subnets          = ["${aws_subnet.pub-a.id}", "${aws_subnet.pub-b.id}"]
    security_groups  = ["${aws_security_group.sg3.id}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.tg-group.arn}"
    container_name   = "act1-container"
    container_port   = "80"
  }
}




