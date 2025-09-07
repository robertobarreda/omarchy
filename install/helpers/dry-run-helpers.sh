#!/bin/bash
# Check for --fail flag
SHOULD_FAIL=false
if [ "$1" = "--fail" ]; then
  SHOULD_FAIL=true
fi
export SHOULD_FAIL

# Mock function that generates test output
generate_test_output() {
  local phase="$1"
  local iterations=${2:-30}

  echo "Starting $phase phase..." >>"$LOG_FILE"
  for i in $(seq 1 $iterations); do
    case $((i % 5)) in
    0) echo "[$phase] Installing package $i of $iterations: package-name-$i" >>"$LOG_FILE" ;;
    1) echo "[$phase] Configuring component-$i..." >>"$LOG_FILE" ;;
    2) echo "[$phase] Checking dependencies for module-$i" >>"$LOG_FILE" ;;
    3) echo "[$phase] Processing file /etc/config/item-$i.conf" >>"$LOG_FILE" ;;
    4) echo "[$phase] Running hook script-$i.sh" >>"$LOG_FILE" ;;
    esac

    # Occasionally output longer lines
    if [ $((i % 7)) -eq 0 ]; then
      echo "[$phase] Very long output line that should be truncated: $(printf '=%.0s' {1..100})" >>"$LOG_FILE"
    fi

    # Occasionally output multiple lines
    if [ $((i % 10)) -eq 0 ]; then
      echo "[$phase] Batch operation $i:" >>"$LOG_FILE"
      echo "  - Subitem A completed" >>"$LOG_FILE"
      echo "  - Subitem B completed" >>"$LOG_FILE"
      echo "  - Subitem C completed" >>"$LOG_FILE"
    fi

    sleep 0.1
  done
  echo "[$phase] Phase completed successfully." >>"$LOG_FILE"
}

# Mock run functions
run_preparation() {
  generate_test_output "Preparation" 20
}

run_packaging() {
  generate_test_output "Packaging" 40
  if [ "$SHOULD_FAIL" = true ]; then
    echo "[Packaging] ERROR: Simulated failure for testing" >>"$LOG_FILE"
    return 1 # Use return instead of exit to allow trap to fire
  fi
}

run_configuration() {
  generate_test_output "Configuration" 35
}

run_login() {
  generate_test_output "Login" 15
}

run_finishing() {
  generate_test_output "Finishing" 10
}

# Get logo width helper
get_logo_width() {
  awk '{ if (length > max) max = length } END { print max+0 }' "$LOGO_PATH" 2>/dev/null || echo 0
}

