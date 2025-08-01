#!/usr/bin/env python3

"""
ssl_expiry_checker.py

Checks the SSL certificate expiry date for a list of domains or IPs and
warns if any certificates are expiring within the defined threshold.

Useful for proactively avoiding expired cert outages in production environments.

Author: abg1122
"""

import socket
import ssl
import datetime

# === Configuration ===

HOSTS = [
    ("google.com", 443),
    ("expired.badssl.com", 443),
    ("your.internal.host", 443)
]

EXPIRY_THRESHOLD_DAYS = 30  # Warn if cert expires in less than this

# =======================


def get_expiry_date(host, port):
    """Returns the SSL cert expiry date for the given host."""
    try:
        context = ssl.create_default_context()
        with socket.create_connection((host, port), timeout=5) as sock:
            with context.wrap_socket(sock, server_hostname=host) as ssock:
                cert = ssock.getpeercert()
                expiry_str = cert['notAfter']
                expiry_date = datetime.datetime.strptime(expiry_str, "%b %d %H:%M:%S %Y %Z")
                return expiry_date
    except Exception as e:
        print(f"Error retrieving cert for {host}:{port} - {e}")
        return None


def main():
    print("Starting SSL certificate expiry check...\n")
    now = datetime.datetime.utcnow()

    for host, port in HOSTS:
        expiry_date = get_expiry_date(host, port)
        if expiry_date:
            days_left = (expiry_date - now).days
            status = "OK"
            if days_left <= EXPIRY_THRESHOLD_DAYS:
                status = "EXPIRING SOON"
            print(f"{host}:{port} - Expires in {days_left} days ({status})")
        else:
            print(f"{host}:{port} - Could not retrieve certificate.\n")


if __name__ == "__main__":
    main()
