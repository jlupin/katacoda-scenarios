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

  echo -n "Downloading jpcc-core@1.6.1..."
  spin_until "/opt/.jpcc-core-downloaded"

  echo -n "Downloading jpcc-client@1.6.1..."
  spin_until "/opt/.jpcc-client-downloaded"

  echo -n "Preparing jlupin configuration for NODE_1..."
  spin_until "/opt/.jlupin1-setup"

  echo -n "Preparing jlupin configuration for NODE_2..."
  spin_until "/opt/.jlupin2-setup"

  echo -n "Starting jlupin platform on NODE_1..."
  spin_until "/opt/.jlupin1-started"

  echo -n "Waiting for exchange app to be available on NODE_1 (starting multiple microservices). This can take a while (up to 3 minutes).."
  spin_until "/opt/.exchange1-available"

  echo -n "Starting jlupin platform on NODE_2..."
  spin_until "/opt/.jlupin2-started"

  echo -n "Waiting for exchange app to be available on NODE_2 (starting multiple microservices). This can take a while (up to 3 minutes).."
  spin_until "/opt/.exchange2-available"

  echo -n "Preparing JLupin Platform Control Center - Core..."
  spin_until "/opt/.jpcc-core-prepared"

  echo -n "Starting JLupin Platform Control Center - Core..."
  spin_until "/opt/.jpcc-core-started"

  echo -n "Preparing JLupin Platform Control Center - Client..."
  spin_until "/opt/.jpcc-client-prepared"

  echo -n "Starting Jlupin Platform Control Center - Client..."
  spin_until "/opt/.jpcc-client-started"
}

show_progress
