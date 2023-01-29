#!/bin/bash

# Comprimir amb: folder=`basename "$PWD"` && zip -r ../$folder.zip . -x '**/.*' -x '**/__MACOSX' -x '*.zip'

reset
rm -f ./bin/*.* 
mkdir -p ./bin
cp -r ./assets ./bin

if [[ $OSTYPE == 'linux-gnu' ]]; then
    javac --module-path ./lib/javafx-linux/lib:./assets --add-modules javafx.controls,javafx.fxml -cp "./:./bin/:./lib/Java-WebSocket-1.5.3.jar:./lib/slf4j-api-2.0.3.jar:./lib/slf4j-simple-2.0.3.jar:./lib/gson-2.9.1.jar" -d ./bin/ ./src/*.java
    java  --module-path ./lib/javafx-linux/lib:./assets --add-modules javafx.controls,javafx.fxml -cp "./:./bin/:./lib/Java-WebSocket-1.5.3.jar:./lib/slf4j-api-2.0.3.jar:./lib/slf4j-simple-2.0.3.jar:./lib/gson-2.9.1.jar" Main
fi

if [[ $OSTYPE == 'darwin'* ]] && [[ $(arch) == 'i386' ]]; then
    javac --module-path ./lib/javafx-osx-x86/lib:./assets --add-modules javafx.controls,javafx.fxml -cp "./:./bin/:./lib/Java-WebSocket-1.5.3.jar:./lib/slf4j-api-2.0.3.jar:./lib/slf4j-simple-2.0.3.jar:./lib/gson-2.9.1.jar" -d ./bin/ ./src/*.java
    java  --module-path ./lib/javafx-osx-x86/lib:./assets --add-modules javafx.controls,javafx.fxml -cp "./:./bin/:./lib/Java-WebSocket-1.5.3.jar:./lib/slf4j-api-2.0.3.jar:./lib/slf4j-simple-2.0.3.jar:./lib/gson-2.9.1.jar" -Xdock:icon=./assets/icon.png Main
fi

if [[ $OSTYPE == 'darwin'* ]] && [[ $(arch) == 'arm64' ]]; then
    javac --module-path ./lib/javafx-osx-arm/lib:./assets --add-modules javafx.controls,javafx.fxml -cp "./:./bin/:./lib/Java-WebSocket-1.5.3.jar:./lib/slf4j-api-2.0.3.jar:./lib/slf4j-simple-2.0.3.jar:./lib/gson-2.9.1.jar" -d ./bin/ ./src/*.java
    java  --module-path ./lib/javafx-osx-arm/lib:./assets --add-modules javafx.controls,javafx.fxml -cp "./:./bin/:./lib/Java-WebSocket-1.5.3.jar:./lib/slf4j-api-2.0.3.jar:./lib/slf4j-simple-2.0.3.jar:./lib/gson-2.9.1.jar"  -Xdock:icon=./assets/icon.png Main
fi