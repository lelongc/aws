#!/bin/bash
set -e

# Print environment information
echo "Java version:"
java -version

echo "Gradle version:"
gradle --version

echo "Android SDK tools version:"
sdkmanager --version

# Check if keystore environment variables are provided
if [ -n "$KEYSTORE_BASE64" ] && [ -n "$KEYSTORE_PASSWORD" ] && [ -n "$KEY_ALIAS" ] && [ -n "$KEY_PASSWORD" ]; then
  echo "Decoding keystore provided via environment variables..."
  mkdir -p /app/keystore
  echo "$KEYSTORE_BASE64" | base64 -d > /app/keystore/release.keystore
  echo "keystore.location=/app/keystore/release.keystore" > /app/keystore.properties
  echo "keystore.password=$KEYSTORE_PASSWORD" >> /app/keystore.properties
  echo "key.alias=$KEY_ALIAS" >> /app/keystore.properties
  echo "key.password=$KEY_PASSWORD" >> /app/keystore.properties
  echo "Keystore configured successfully."
fi

# Execute the passed command
exec "$@"
