#!/bin/bash

cd /root/cs350-os161/os161-1.99
./configure --ostree=/root/cs350-os161/root --toolprefix=cs350-
cd /root/cs350-os161/os161-1.99/kern/conf
./config ASST0
cd /root/cs350-os161/os161-1.99/kern/compile/ASST0
bmake depend
bmake
bmake install
cd /root/cs350-os161/os161-1.99
bmake
bmake install
cd /root/cs350-os161/root
cp /root/sys161/sys161.conf sys161.conf
