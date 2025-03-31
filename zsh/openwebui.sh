openwebui() {
  # Define some colors and emojis for feedback
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  RED='\033[0;31m'
  NC='\033[0m' # No color
  CHECK_MARK="✅"
  WARNING_SIGN="⚠️"
  ERROR_SIGN="❌"
  INFO="ℹ️"
  spin="-\\|/"
  
  # Spinner function using Nerd Font dots
  spinner() {
    pid=$1
    delay=0.1
    dots=("⣾" "⣽" "⣻" "⢿" "⡿" "⣟" "⣯" "⣷")
    echo -n " "  # Initial space for the spinner
    while kill -0 $pid 2>/dev/null; do
      for dot in "${dots[@]}"; do
        echo -ne "\r\033[K${YELLOW}${dot}${NC}" >/dev/tty
        sleep $delay
      done
    done
    echo -ne "\r\033[K" >/dev/tty  # Clear the spinner line
    echo  # Add a newline after spinner completes
  }
  
  # Check if Docker is running, if not, start it
  echo  # Add initial spacing
  if ! docker info > /dev/null 2>&1; then
    echo -e "${YELLOW}${WARNING_SIGN} Docker is not running. Attempting to start...${NC}"
    open -a Docker &
    pid=$!
    spinner $pid
    wait $pid
    while ! docker system info > /dev/null 2>&1; do
      sleep 1
    done
    echo -e "${GREEN}${CHECK_MARK} Docker started successfully.${NC}"
  else
    echo -e "${GREEN}${CHECK_MARK} Docker is running.${NC}"
  fi
  echo  # Add spacing after Docker check
  
  # Check if the container is already running
  if docker ps --format '{{.Names}}' | grep -q '^open-webui$'; then
    echo -e "${INFO} ${YELLOW}The 'open-webui' container is already running.${NC}"
    echo -n "Would you like to restart it? (y/N) "
    read "REPLY?>"
    echo
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
      echo -e "${YELLOW}${WARNING_SIGN} Stopping 'open-webui' container...${NC}"
      docker stop open-webui > /dev/null 2>&1 &
      pid=$!
      spinner $pid
      wait $pid
      echo -e "${YELLOW}${WARNING_SIGN} Removing 'open-webui' container...${NC}"
      docker rm open-webui > /dev/null 2>&1 &
      pid=$!
      spinner $pid
      wait $pid
      echo -e "${GREEN}${CHECK_MARK} Container removed successfully.${NC}"
      echo  # Add spacing after container removal
    else
      echo -e "${INFO} Keeping current container running."
      echo  # Add spacing before return
      return 0
    fi
  fi

  # Check if the container exists but stopped, then remove it
  if docker ps -a --format '{{.Names}}' | grep -q '^open-webui$'; then
    echo -e "${YELLOW}${WARNING_SIGN} Removing existing 'open-webui' container...${NC}"
    docker rm open-webui > /dev/null 2>&1 &
    pid=$!
    spinner $pid
    wait $pid
    echo -e "${GREEN}${CHECK_MARK} Removed existing container.${NC}"
    echo  # Add spacing after container removal
  fi

  # Run the container
  echo -e "${INFO} ${YELLOW}Starting 'open-webui' container...${NC}"
  docker run -d -p 8099:8080 -e WEBUI_URL=http://localhost:8099 -v open-webui:/app/backend/data --name open-webui ghcr.io/open-webui/open-webui:latest > /dev/null 2>&1 &
  pid=$!
  spinner $pid
  wait $pid
  
  # Restart nginx server in the machine
  echo -e "${INFO} ${YELLOW}Restarting nginx server...${NC}"
  brew services restart nginx > /dev/null 2>&1 &
  pid=$!
  spinner $pid
  wait $pid
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}${CHECK_MARK} Nginx restarted successfully.${NC}"
  else
    echo -e "${RED}${ERROR_SIGN} Failed to restart Nginx.${NC}"
  fi
  echo  # Add spacing between status messages

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}${CHECK_MARK} 'open-webui' container started successfully.${NC}"
  else
    echo -e "${RED}${ERROR_SIGN} Failed to start 'open-webui' container.${NC}"
  fi
}

