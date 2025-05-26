#!/bin/bash
set -euo pipefail

IPS=("192.168.4.101" "192.168.4.102" "192.168.4.103" "192.168.4.104")
DISPLAYS=(":11" ":12" ":13" ":14")

echo "IPS array: 192.168.4.101 192.168.4.102 192.168.4.103 192.168.4.104"
echo "DISPLAYS array: :11 :12 :13 :14"

for i in "0 1 2 3"; do
  echo "Index: 3, IP: 192.168.4.104, Display: :14"
done

