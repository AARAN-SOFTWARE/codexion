#!/bin/bash

set -e  # Exit on any error

# Ensure script is being run from correct directory
FRONTEND_DIR="/home/devops/workspace/frontend/react"

# Fix file permissions
echo "🔧 Fixing file permissions for project directory..."
sudo chown -R "$(whoami)":"$(whoami)" "$FRONTEND_DIR"

# Move into project directory
cd "$FRONTEND_DIR"

# Load nvm and use Node.js v20
echo "💻 Activating Node.js environment..."
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm use 20

# Install dependencies
echo "📦 Installing frontend dependencies..."
npm install

# Start dev server
echo "🚀 Starting React dev server on http://localhost:5173 ..."
npm run dev
