# System Health Monitor with Email Alerts

## Overview

This project is a simple yet effective **System Health Monitor** implemented as a Bash script running on an AWS EC2 Ubuntu instance. It monitors essential system metrics such as CPU load, memory usage, and disk usage, and sends email alerts every minute using AWS Simple Email Service (SES). The monitoring script is automated via a Linux cron job.

## Features

- Monitors CPU load average, memory usage, and disk usage on the root partition.
- Sends timely email notifications with the health status using AWS SES.
- Automates monitoring with cron to run every minute.
- Uses AWS CLI for sending emails securely.
- Easy to configure and deploy on any Ubuntu-based EC2 instance.

## Prerequisites

- AWS EC2 instance running Ubuntu (e.g., t2.micro).
- AWS CLI installed and configured with appropriate IAM permissions.
- AWS SES setup with verified email addresses (both sender and recipient) in the same region.
- Bash shell available on the system.

## Setup Instructions

1. **Clone the script**

   Save the `system-health.sh` script on your EC2 instance:

   vi system-health.sh

2. **Make the script executable**
   
   chmod +x system-health.sh

3. **Replace the placeholder emails with your verified SES sender and recipient emails**

   FROM_EMAIL="your-verified-email@example.com"
   TO_EMAIL="your-verified-email@example.com"

4. **Test the script manually**

    ./system-health.sh

5. **Automate with cron**

   crontab -e

6. **Add this line to run the script every minute and log output**

   * * * * * /home/ubuntu/system-health.sh >> /home/ubuntu/system-health.log 2>&1

7. **Verify cron job, Check the log file for output and errors**

   tail -f /home/ubuntu/system-health.log



## How It Works
- The script collects system metrics using standard Linux commands (uptime, free, df).

- It formats an email body with the collected data.

- Uses AWS CLI SES send-email command to send the alert.

- Cron triggers this script every minute to provide continuous monitoring
