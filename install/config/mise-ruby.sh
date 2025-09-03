#!/bin/bash

# Install Ruby using gcc-14 for compatibility
mise settings set ruby.ruby_build_opts "CC=gcc-14 CXX=g++-14"

# Trust .ruby-version
mise settings add idiomatic_version_file_enable_tools ruby

# Check if architecture is x86_64
if [ "$(uname -m)" != "x86_64" ]; then
  echo "Skipping prebuilt Ruby installation: not x86_64 architecture (detected: $(uname -m))"
  exit 0
fi

RUBY_VERSION="3.4.5"
RUBY_TARBALL="ruby-${RUBY_VERSION}-rails-8.0.2.1-x86_64.tar.gz"
RUBY_URL="https://pkgs.omarchy.org/ruby/${RUBY_TARBALL}"
MISE_RUBY_DIR="$HOME/.local/share/mise/installs/ruby"
OFFLINE_CACHE="/var/cache/omarchy/ruby"

mkdir -p "$MISE_RUBY_DIR"

if [ -n "$OMARCHY_OFFLINE_INSTALL" ]; then
  echo "Installing Ruby from offline cache..."
  tar -xzf "${OFFLINE_CACHE}/${RUBY_TARBALL}" -C "$MISE_RUBY_DIR"
else
  echo "Downloading pre-built Ruby ${RUBY_VERSION}..."
  curl -fsSL "$RUBY_URL" | tar -xz -C "$MISE_RUBY_DIR"
fi

# Fix hardcoded paths if this is a relocated installation
RUBY_INSTALL_DIR="$MISE_RUBY_DIR/${RUBY_VERSION}"
if [ -d "$RUBY_INSTALL_DIR" ]; then
  echo "Fixing hardcoded paths in Ruby installation..."

  # Fix shebang lines in bin executables
  find "$RUBY_INSTALL_DIR/bin" -type f -exec grep -l "^#!/home/" {} \; 2>/dev/null | while read -r file; do
    sed -i "1s|^#!/home/[^/]*/|#!$HOME/|" "$file"
  done

  # Fix rbconfig.rb
  RBCONFIG="$RUBY_INSTALL_DIR/lib/ruby/3.4.0/x86_64-linux/rbconfig.rb"
  if [ -f "$RBCONFIG" ]; then
    sed -i "s|/home/[^/]*/|$HOME/|g" "$RBCONFIG"
  fi

  # Fix pkgconfig file
  PKGCONFIG="$RUBY_INSTALL_DIR/lib/pkgconfig/ruby-3.4.pc"
  if [ -f "$PKGCONFIG" ]; then
    sed -i "s|/home/[^/]*/|$HOME/|g" "$PKGCONFIG"
  fi

  echo "Path relocation complete"
fi

mise use --global "ruby@${RUBY_VERSION}"
