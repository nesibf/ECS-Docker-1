resource "aws_appautoscaling_target" "ecs_target1" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/clusterDev/act2-Service"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_up_policy1" {
  name               = "scale_up_policy1"
  depends_on         = [aws_appautoscaling_target.ecs_target1]
  service_namespace  = "ecs"
  resource_id        = "service/clusterDev/act2-Service"
  scalable_dimension = "ecs:service:DesiredCount"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}





resource "aws_appautoscaling_policy" "scale_down_policy1" {
  name               = "scale_down_policy1"
  depends_on         = [aws_appautoscaling_target.ecs_target1]
  service_namespace  = "ecs"
  resource_id        = "service/clusterDev/act2-Service"
  scalable_dimension = "ecs:service:DesiredCount"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"
    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}











# AWS Auto Scaling - CloudWatch Alarm CPU High
#------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "cpu_high1" {
  alarm_name          = "cpu-high1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3                              #"The number of periods over which data is compared to the specified threshold for max cpu metric alarm"
  metric_name         = "CPUUtilization1"
  namespace           = "AWS/ECS"
  period              = 60                        #"The number of periods over which data is compared to the specified threshold for min cpu metric alarm"
  statistic           = "Maximum"
  threshold           = 80
  
  alarm_actions = [aws_appautoscaling_policy.scale_up_policy1.arn]

  
}






# AWS Auto Scaling - CloudWatch Alarm CPU Low
#------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "cpu_low1" {
  alarm_name          = "cpu-low1"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization1"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 10
  
  alarm_actions = [aws_appautoscaling_policy.scale_down_policy1.arn]

  
}