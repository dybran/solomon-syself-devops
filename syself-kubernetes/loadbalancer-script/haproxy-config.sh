#!/bin/bash

# Install, start and configure HAProxy
sudo apt-get update
sudo apt-get install -y haproxy
sudo systemctl start haproxy


echo "frontend kubernetes-frontend
    bind *:6443
    option tcplog
    mode tcp
    default_backend syself-master

backend syself-master
    mode tcp
    balance roundrobin
    option tcp-check
    server master1 ${MASTER1_IP}:6443 check
    server master2 ${MASTER2_IP}:6443 check
    server master3 ${MASTER3_IP}:6443 check

listen stats
    bind *:8500
    mode http
    stats enable
    stats uri /
    stats refresh 10s
    stats admin if LOCALHOST
" >> /etc/haproxy/haproxy.cfg


# Restart Haproxy
sudo systemctl restart haproxy