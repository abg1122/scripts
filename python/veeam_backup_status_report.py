#!/usr/bin/env python3

"""
veeam_backup_status_report.py

Fetches backup job status from Veeam Backup & Replication API
and logs the output as a health report.

Author: abg1122
"""

import requests
from requests.auth import HTTPBasicAuth
import datetime
import csv

# Veeam API Configuration
VBR_HOST = "https://veeam-server:9398"
USERNAME = "your.veeam.user"
PASSWORD = "yourpassword"
REPORT_FILE = "veeam_backup_report.csv"

# Disable SSL warnings (optional but common in test labs)
requests.packages.urllib3.disable_warnings()


def get_api_token():
    """Authenticates to Veeam API and returns session token."""
    url = f"{VBR_HOST}/api/sessionMngr/?v=latest"
    response = requests.post(url, auth=HTTPBasicAuth(USERNAME, PASSWORD), verify=False)

    if response.status_code == 201:
        return response.headers.get('X-RestSvcSessionId')
    else:
        raise Exception(f"Failed to authenticate: {response.status_code} {response.text}")


def get_backup_jobs(headers):
    """Fetch list of backup jobs with their status."""
    url = f"{VBR_HOST}/api/jobs?format=Entity"
    response = requests.get(url, headers=headers, verify=False)

    if response.status_code == 200:
        return response.json().get('Refs', [])
    else:
        raise Exception(f"Failed to retrieve job list: {response.status_code}")


def generate_report(jobs):
    """Generate CSV report from job list."""
    with open(REPORT_FILE, mode='w', newline='') as csv_file:
        writer = csv.writer(csv_file)
        writer.writerow(["Job Name", "Type", "Status", "Last Result", "Last Run"])

        for job in jobs:
            name = job.get('Name', 'N/A')
            href = job.get('Href')
            job_detail = requests.get(f"{VBR_HOST}{href}", headers=headers, verify=False).json()

            status = job_detail.get('Status')
            last_result = job_detail.get('LastResult')
            last_run = job_detail.get('LastRun')

            writer.writerow([name, job_detail.get('JobType'), status, last_result, last_run])


if __name__ == "__main__":
    print("Connecting to Veeam Backup & Replication API...")

    try:
        token = get_api_token()
        headers = {
            "X-RestSvcSessionId": token,
            "Accept": "application/json"
        }

        jobs = get_backup_jobs(headers)
        if not jobs:
            print("No jobs found.")
        else:
            generate_report(jobs)
            print(f"Backup report saved to: {REPORT_FILE}")

    except Exception as e:
        print(f"Error: {e}")
