#!/bin/bash

# Script to fix Gradle server connection issue
# This script helps set up Java 11+ for Gradle

echo "=== Gradle Server Fix Script ==="
echo ""
echo "Current Java version:"
java -version
echo ""

echo "To fix the Gradle connection issue, you need Java 11 or newer."
echo ""
echo "Option 1: Install Java via Homebrew (recommended)"
echo "  brew install openjdk@17"
echo "  sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk"
echo ""
echo "Option 2: Download and install Java manually"
echo "  Visit: https://adoptium.net/ or https://www.oracle.com/java/technologies/downloads/"
echo "  Download Java 17 LTS for macOS"
echo ""
echo "After installing Java 11+, run:"
echo "  export JAVA_HOME=\$(/usr/libexec/java_home -v 17)"
echo "  cd android && ./gradlew --stop"
echo "  cd android && ./gradlew tasks"
echo ""

# Try to stop Gradle daemon
echo "Stopping any running Gradle daemons..."
cd android && ./gradlew --stop 2>/dev/null || echo "No daemons to stop"

echo ""
echo "Once Java 11+ is installed, restart your IDE/editor to pick up the new Java version."

