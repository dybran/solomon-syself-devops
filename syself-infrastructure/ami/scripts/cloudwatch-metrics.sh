#!/bin/bash

# Update package list
echo "Updating package list..."
sudo apt-get update -y

# Download and install the CloudWatch Agent
echo "Downloading and installing the CloudWatch Agent..."
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
rm ./amazon-cloudwatch-agent.deb

# Ensure the directory exists
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/bin

# Create CloudWatch Agent configuration file
echo "Creating CloudWatch Agent configuration file..."
cat <<EOF | sudo tee /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
    "agent": {
        "metrics_collection_interval": 60,
        "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
    },
    "metrics": {
        "namespace": "CustomMetrics",
        "metrics_collected": {
            "mem": {
                "measurement": [
                    {"name": "mem_used_percent", "unit": "Percent"}
                ],
                "metrics_collection_interval": 60
            }
        }
    }
}
EOF

# Start the CloudWatch Agent
echo "Starting CloudWatch Agent..."
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s

echo "CloudWatch Agent setup complete."
