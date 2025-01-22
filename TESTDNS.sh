#!/bin/bash

# DNS server to test
DNS_SERVER="192.168.56.10"

# List of domains to query
DOMAINS=(
  "ns.sri.ies."
  "mirror.sri.ies."
  "ftp.sri.ies."
)

# Log file for results
LOG_FILE="dns_test_results.log"

# Function to test DNS queries
test_dns() {
  local domain=$1
  echo "Querying $domain..."
  nslookup $domain $DNS_SERVER >> $LOG_FILE 2>&1
  if [ $? -eq 0 ]; then
    echo "Success: $domain resolved correctly."
  else
    echo "Error: Unable to resolve $domain."
  fi
}

# Main script
echo "Starting DNS test for server $DNS_SERVER"
echo "Results will be logged in $LOG_FILE"
echo "----------------------------------------" > $LOG_FILE

for domain in "${DOMAINS[@]}"; do
  test_dns $domain
done

echo "DNS test completed. Check $LOG_FILE for details."
