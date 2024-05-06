#!/bin/sh

ssh-keygen -t rsa -b 4096 -f "./id_rsa" -N "$SSH_KEY"
chmod 600 ./id_rsa
