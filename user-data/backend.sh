#!/bin/bash

# Update packages
apt-get update -y

# Install Python and pip
apt-get install -y python3 python3-pip python3-venv

# Create Python virtual environment
python3 -m venv /opt/flask-venv

# Verify installation
python3 --version