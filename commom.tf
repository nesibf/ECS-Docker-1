

resource "aws_lb" "app-lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg2.id]
  subnets            = ["${aws_subnet.pub-a.id}", "${aws_subnet.pub-b.id}"]

}

resource "aws_lb_target_group" "tg-group" {     
  name        = "tg-group"
  port        = "80"
  protocol    = "HTTP"                                                #this target_group attach with first SERVICE-1
  vpc_id      = "${aws_vpc.createVPC.id}"
  target_type = "ip"

}



resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = "80"
  protocol          = "HTTP"
                                                                   #listener should be one 
  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.tg-group.arn
      }

      
      

      
    }
  }
}




resource "aws_lb_target_group" "tg1-group" {     
  name        = "tg1-group"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.createVPC.id}"
  target_type = "ip"

  

}
                                                                                   #THIS target_group AND aws_lb_listener_rule attach with SERVICE-2


resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.lb-listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg1-group.arn
  }

  condition {
    path_pattern {
      values = ["/index.html"]
    }
  }

  condition {
    query_string {
      key   = "health"
      value = "check"
    }
  }
}


