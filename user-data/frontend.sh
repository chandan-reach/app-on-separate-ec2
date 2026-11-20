#!/bin/bash

# Update packages
apt-get update -y

# Install Node.js and npm
apt-get install -y nodejs npm

# Verify installation
node --version
npm --version