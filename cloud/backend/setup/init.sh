#!/bin/bash

set -e

TARGET_DIR="/var/www/backend"

echo "🌀 Welcome to Codexion Setup CLI 🌀"
echo "----------------------------------"
echo "Checking environment..."

# Ensure backend exists
if [ ! -d "/workspace" ]; then
  echo "❌ No backend found at /workspace"
  exit 1
fi

# Create the target directory
mkdir -p $TARGET_DIR

# Copy backend files
cp -r /workspace/* $TARGET_DIR

echo "✅ Backend copied to $TARGET_DIR"

# Create and activate virtualenv
cd $TARGET_DIR
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies
if [ -f "requirements.txt" ]; then
  pip install --upgrade pip
  pip install -r requirements.txt
fi

# Optional: interactive shell or menu
echo "🧠 Codexion CLI is ready!"
PS3="Choose an action: "
select opt in "Start App" "Exit"; do
  case $opt in
    "Start App")
      echo "🚀 Starting app on http://localhost:8000"
      .venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000
      break
      ;;
    "Exit")
      echo "👋 Exiting Codexion CLI."
      break
      ;;
    *) echo "Invalid option $REPLY";;
  esac
done
