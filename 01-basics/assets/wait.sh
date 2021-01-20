#!/bin/bash

spin_until()
{
  local -r delay='0.75'
  local spinstr='\|/-'
  local temp

  while true; do 
    sudo grep -i "done" $1 &> /dev/null
    if [[ "$?" -ne 0 ]]; then     
      temp="${spinstr#?}"
      printf " [%c]  " "${spinstr}"
      spinstr=${temp}${spinstr%"${temp}"}
      sleep "${delay}"
      printf "\b\b\b\b\b\b"
    else
      break
    fi
  done
  printf "    \b\b\b\b"
  echo ""
  echo "Done!"
}

show_progress()
{
  echo -n "Installing system dependencies..."
  spin_until "/opt/.sys-deps-installed"

  echo -n "Downloading jlupin@1.6.1..."
  spin_until "/opt/.jlupin-downloaded"

  echo -n "Downloading example app..."
  spin_until "/opt/.app-downloaded"

  echo -n "Preparing jlupin configuration..."
  spin_until "/opt/.jlupin-setup"

  echo -n "Starting jlupin platform..."
  spin_until "/opt/.jlupin-started"

  echo -n "Waiting for example app to be available..."
  spin_until "/opt/.app-available"
}

show_progress
