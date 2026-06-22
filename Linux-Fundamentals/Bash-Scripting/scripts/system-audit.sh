#!/bin/bash

# System Security Audit Script
# Purpose: Quick security check of system

echo "=== System Security Audit ==="
echo ""

echo "1. System Information:"
echo "Hostname: $(hostname)"
echo "OS: $(lsb_release -d | cut -f2)"
echo ""

echo "2. Users on System:"
cat /etc/passwd | grep -v "/nologin" | grep -v "/false" | cut -d: -f1
echo ""

echo "3. World-Writable Files:"
find / -type f -perm -002 2>/dev/null | grep -v proc | grep -v sys | wc -l
echo "Files found (shown above)"
echo ""

echo "4. SUID Binaries:"
find / -perm -4000 2>/dev/null | wc -l
echo "SUID binaries found"
echo ""

echo "5. Listening Ports:"
ss -tulpn 2>/dev/null | grep LISTEN | wc -l
echo "Services listening"
echo ""

echo "Audit Complete!"
