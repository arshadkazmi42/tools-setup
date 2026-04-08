#!/bin/bash

# Function to detect system architecture
detect_architecture() {
	arch=$(uname -m)
	if [[ "$arch" == "x86_64" ]]; then
		echo "amd64"
	elif [[ "$arch" == "arm64" || "$arch" == "aarch64" ]]; then
		echo "arm64"
	else
		echo "unsupported"
	fi
}

# Determine architecture
ARCH=$(detect_architecture)

if [[ "$ARCH" == "unsupported" ]]; then
	echo "Unsupported architecture: $arch"
	exit 1
fi

# Define Trufflehog version
VERSION="3.94.3"

# Download the correct Trufflehog binary
echo "Downloading Trufflehog for $ARCH..."
wget -q "https://github.com/trufflesecurity/trufflehog/releases/download/v$VERSION/trufflehog_${VERSION}_linux_${ARCH}.tar.gz" -O trufflehog.tar.gz

if [[ $? -ne 0 ]]; then
	echo "Failed to download Trufflehog for $ARCH."
	exit 1
fi

# Extract Trufflehog
echo "Extracting Trufflehog..."
tar -xvf trufflehog.tar.gz

# Remove unnecessary files
echo "Cleaning up..."
rm -rf LICENSE README.md trufflehog.tar.gz

# Move Trufflehog to /bin
echo "Installing Trufflehog..."
sudo cp trufflehog /bin/

# Remove extracted binary
rm -rf trufflehog

# Verify installation
echo "Verifying Trufflehog installation..."
if command -v trufflehog >/dev/null 2>&1; then
	trufflehog --version
	echo "Trufflehog installed successfully!"
else
	echo "Trufflehog installation failed."
	exit 1
fi
