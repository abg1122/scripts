#!/usr/bin/env python3
# aws_security_group_audit.py
# Identifies overly permissive security group rules in AWS

# Author: abg1122

import boto3

def is_insecure(ip_range):
    return ip_range == "0.0.0.0/0"

def check_security_groups():
    ec2 = boto3.client("ec2")
    sg_response = ec2.describe_security_groups()

    print("🔍 Scanning Security Groups for insecure rules...\n")

    for sg in sg_response["SecurityGroups"]:
        sg_name = sg.get("GroupName", "Unnamed")
        sg_id = sg["GroupId"]

        for permission in sg.get("IpPermissions", []):
            from_port = permission.get("FromPort")
            to_port = permission.get("ToPort")
            ip_ranges = permission.get("IpRanges", [])

            for ip_range in ip_ranges:
                cidr = ip_range.get("CidrIp", "")
                if is_insecure(cidr) and from_port in [22, 3389]:
                    print(f"{sg_name} ({sg_id}) allows {cidr} on port {from_port}")

if __name__ == "__main__":
    try:
        check_security_groups()
    except Exception as e:
        print(f"Error: {e}")
