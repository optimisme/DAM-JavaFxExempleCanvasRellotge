#!/bin/bash

# run.sh

# Set MAVEN_OPTS environment variable
if [[ "$OSTYPE" == "darwin"* ]]; then
    export MAVEN_OPTS="-Xdock:icon=./target/classes/icons/iconOSX.png --add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.nio=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export MAVEN_OPTS="--add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.nio=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED"
fi

# Resta de l'script

# Check for the first argument and set it as the main class
mainClass=$1

echo "Setting MAVEN_OPTS to: $MAVEN_OPTS"
echo "Main Class: $mainClass"

# Execute mvn command with the profile and main class as arguments
execArg="-PrunMain -Dexec.mainClass=$mainClass"
echo "Exec args: $mainClass"

# Execute mvn command
mvn clean test-compile exec:java $execArg 