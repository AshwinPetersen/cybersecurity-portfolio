#!/bin/bash

# Advanced Security Check Script
# Checks for common vulnerabilities

CRITICAL=0
HIGH=0
MEDIUM=0

echo "=== Advanced Security Check ==="
echo ""

# Check 1: World-writable files
WORLD_WRITABLE=$(find / -type f -perm -002 2>/dev/null | grep -v proc | grep -v sys | wc -l)
if [ $WORLD_WRITABLE -gt 0 ]; then
    echo " CRITICAL: $WORLD_WRITABLE world-writable files found"
    CRITICAL=$((CRITICAL + 1))
else
    echo "✓ GOOD: No world-writable files found"
fi
echo ""

# Check 2: Unused user accounts
UNUSED_USERS=$(cat /etc/passwd | grep -E "testuser|dummy" | wc -l)
if [ $UNUSED_USERS -gt 0 ]; then
    echo " HIGH: $UNUSED_USERS unused test accounts found"
    HIGH=$((HIGH + 1))
else
    echo "✓ GOOD: No test accounts found"
fi
echo ""

# Check 3: Root-owned SUID files
ROOT_SUID=$(find / -perm -4000 -user root 2>/dev/null | wc -l)
echo " INFO: $ROOT_SUID SUID binaries owned by root"
echo ""

# Check 4: Listening on external ports
EXTERNAL=$(ss -tulpn 2>/dev/null | grep "0.0.0.0" | wc -l)
if [ $EXTERNAL -gt 0 ]; then
    echo " HIGH: $EXTERNAL services listening on all interfaces"
    HIGH=$((HIGH + 1))
else
    echo "✓ GOOD: No services exposed to external network"
fi
echo ""

# Summary
echo "=== Summary ==="
echo "Critical Issues: $CRITICAL"
echo "High Issues: $HIGH"
echo "Medium Issues: $MEDIUM"
