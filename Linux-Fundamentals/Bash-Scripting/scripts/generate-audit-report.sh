#!/bin/bash

# Generate Security Audit Report
# Creates timestamped report file

REPORT_FILE="audit-report-$(date +%Y%m%d-%H%M%S).txt"

{
    echo "========================================"
    echo "Security Audit Report"
    echo "Generated: $(date)"
    echo "========================================"
    echo ""
    
    echo "SYSTEM INFORMATION"
    echo "Hostname: $(hostname)"
    echo "OS: $(lsb_release -d | cut -f2)"
    echo "Kernel: $(uname -r)"
    echo ""
    
    echo "SECURITY FINDINGS"
    echo "World-Writable Files: $(find / -type f -perm -002 2>/dev/null | grep -v proc | grep -v sys | wc -l)"
    echo "SUID Binaries: $(find / -perm -4000 2>/dev/null | wc -l)"
    echo "Active Users: $(cat /etc/passwd | grep -v "/nologin" | grep -v "/false" | wc -l)"
    echo "Listening Services: $(ss -tulpn 2>/dev/null | grep LISTEN | wc -l)"
    echo ""
    
    echo "FAILED LOGIN ATTEMPTS (Last 7 days)"
    sudo grep "Failed password" /var/log/syslog 2>/dev/null | tail -5 || echo "No failed attempts found"
    echo ""
    
    echo "Report Complete"
    
} > "$REPORT_FILE"

echo "Report generated: $REPORT_FILE"
cat "$REPORT_FILE"

