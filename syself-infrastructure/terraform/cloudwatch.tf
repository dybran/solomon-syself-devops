resource "aws_cloudwatch_metric_alarm" "scale_up_alarm_memory" {
  alarm_name          = "${var.args.cluster_name}-scale-up-alarm-memory"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "mem_used_percent"
  namespace           = "CustomMetrics"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Trigger scale-up policy if memory usage is above 80%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.syself_worker_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm_memory" {
  alarm_name          = "${var.args.cluster_name}-scale-down-alarm-memory"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "mem_used_percent"
  namespace           = "CustomMetrics"
  period              = 300
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "Trigger scale-down policy if memory usage is below 20%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.syself_worker_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.args.cluster_name}-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.syself_worker_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.args.cluster_name}-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.syself_worker_asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "${var.args.cluster_name}-scale-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Trigger scale-up policy if CPU usage is above 80%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.syself_worker_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
  ok_actions    = [aws_autoscaling_policy.scale_down.arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "${var.args.cluster_name}-scale-down-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "Trigger scale-down policy if CPU usage is below 20%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.syself_worker_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}