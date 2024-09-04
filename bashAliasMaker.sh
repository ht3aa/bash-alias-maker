#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <add|delete> <alias_name> [alias_command]"
  exit 1
fi

# Assign arguments to variables
ACTION="$1"
ALIAS_NAME="$2"
ALIAS_COMMAND="$3"

# Path to the .bashrc file
BASHRC_FILE="$HOME/.bashrc"

# Function to add an alias
add_alias() {
  # Check if the alias already exists in .bashrc
  if grep -q "alias $ALIAS_NAME=" "$BASHRC_FILE"; then
    echo "Alias '$ALIAS_NAME' already exists in $BASHRC_FILE."
  else
    # Append the alias to .bashrc
    echo "alias $ALIAS_NAME='$ALIAS_COMMAND'" >>"$BASHRC_FILE"
    echo "Alias '$ALIAS_NAME' added to $BASHRC_FILE."
  fi
}

# Function to delete an alias
delete_alias() {
  # Backup the original .bashrc
  BACKUP_FILE="$BASHRC_FILE.bak"
  cp "$BASHRC_FILE" "$BACKUP_FILE"

  # Remove the alias from .bashrc
  sed -i "/alias $ALIAS_NAME=/d" "$BASHRC_FILE"

  # Check if the alias was successfully removed
  if grep -q "alias $ALIAS_NAME=" "$BASHRC_FILE"; then
    echo "Failed to remove alias '$ALIAS_NAME'."
  else
    echo "Alias '$ALIAS_NAME' removed from $BASHRC_FILE."
  fi
}

# Handle the action based on the first argument
case "$ACTION" in
add)
  if [ -z "$ALIAS_COMMAND" ]; then
    echo "For 'add' action, you must provide an alias command."
    exit 1
  fi
  add_alias
  ;;
delete)
  delete_alias
  ;;
*)
  echo "Invalid action: $ACTION. Use 'add' or 'delete'."
  exit 1
  ;;
esac

# Source the .bashrc file to apply the changes
source "$BASHRC_FILE"
echo ".bashrc has been sourced. Changes applied."
