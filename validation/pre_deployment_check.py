#!/usr/bin/env python3
# pre_deployment_check.py
# Validates environment, dependencies, and basic connectivity before deployment

# Author: abg1122

import os
import shutil
import socket
import sys

REQUIRED_ENV_VARS = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
REQUIRED_COMMANDS = ["terraform", "ansible", "docker"]
REQUIRED_PORTS = [22, 443]
TARGET_HOST = "github.com"

def check_env_vars():
    print("🔍 Checking required environment variables...")
    for var in REQUIRED_ENV_VARS:
        if not os.getenv(var):
            print(f"❌ Missing: {var}")
            return False
    return True

def check_commands():
    print("🔍 Checking required command-line tools...")
    for cmd in REQUIRED_COMMANDS:
        if not shutil.which(cmd):
            print(f"❌ Command not found: {cmd}")
            return False
    return True

def check_ports(host, ports):
    print(f"🔍 Checking connectivity to {host} on ports {ports}...")
    for port in ports:
        try:
            with socket.create_connection((host, port), timeout=5):
                print(f"✅ Port {port} reachable.")
        except Exception:
            print(f"❌ Cannot connect to port {port} on {host}")
            return False
    return True

if __name__ == "__main__":
    if not (check_env_vars() and check_commands() and check_ports(TARGET_HOST, REQUIRED_PORTS)):
        print("\n❗Pre-deployment validation failed. Please fix issues before proceeding.")
        sys.exit(1)
    print("\n✅ All checks passed. Ready for deployment.")
