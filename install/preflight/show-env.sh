#!/bin/bash

# Show installation environment variables
gum log --level info "Installation Environment:"

env | grep -E "^(OMARCHY_CHROOT_INSTALL|OMARCHY_OFFLINE_INSTALL|OMARCHY_USER_NAME|OMARCHY_USER_EMAIL|USER|HOME|OMARCHY_REPO|OMARCHY_REF)=" | sort | while IFS= read -r var; do
  gum log --level info "  $var"
done
