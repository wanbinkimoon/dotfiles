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
  
  # Spinner function
  spinner() {
    pid=$1
    delay=0.1
    while [ "$(ps a | awk '{print $1}' | grep "$pid")" ]; do
      for i in $spin; do
        echo -ne "$i" >/dev/tty
        sleep $delay
        echo -ne "\b" >/dev/tty
      done
    done
  }
  
  # Check if Docker is running, if not, start it
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
  
  # Check if the container is already running
  if docker ps --format '{{.Names}}' | grep -q '^open-webui$'; then
    echo -e "${INFO} ${GREEN}${CHECK_MARK} The 'open-webui' container is already running.${NC}"
    return 0
  fi

  # Check if the container exists but stopped, then remove it
  if docker ps -a --format '{{.Names}}' | grep -q '^open-webui$'; then
    echo -e "${YELLOW}${WARNING_SIGN} Removing existing 'open-webui' container...${NC}"
    docker rm open-webui > /dev/null 2>&1 &
    pid=$!
    spinner $pid
    wait $pid
    echo -e "${GREEN}${CHECK_MARK} Removed existing container.${NC}"
  fi

  # Run the container
  echo -e "${INFO} ${YELLOW}Starting 'open-webui' container...${NC}"
  docker run -d -p 8099:8080 -e WEBUI_URL=http://localhost:8099 -v open-webui:/app/backend/data --name open-webui ghcr.io/open-webui/open-webui:main > /dev/null 2>&1 &
  pid=$!
  spinner $pid
  wait $pid
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}${CHECK_MARK} 'open-webui' container started successfully.${NC}"
  else
    echo -e "${RED}${ERROR_SIGN} Failed to start 'open-webui' container.${NC}"
  fi
}

