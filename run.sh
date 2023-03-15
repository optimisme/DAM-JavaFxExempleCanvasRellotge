#!/bin/bash

# Comprimir amb: folder=`basename "$PWD"` && zip -r ../$folder.zip . -x '**/.*' -x '**/__MACOSX' -x '*.zip'

reset
rm -f ./bin/*.* 
mkdir -p ./bin
cp -r ./assets ./bin

if [[ $OSTYPE == 'linux-gnu' ]]; then
    javac --module-path ./lib/javafx-linux/lib --add-modules javafx.controls,javafx.fxml -cp "./:./bin/:./lib/Java-WebSocket-1.5.3.jar:./lib/slf4j-api-2.0.3.jar:./lib/slf4j-simple-2.0.3.jar:./lib/json-20220924.jar" -d ./bin/ ./src/*.java
    java  --module-path ./lib/javafx-linux/lib --add-modules javafx.controls,javafx.fxml -cp "./:./bin/:./lib/Java-WebSocket-1.5.3.jar:./lib/slf4j-api-2.0.3.jar:./lib/slf4j-simple-2.0.3.jar:./lib/json-20220924.jar" Main
fi

if [[ $OSTYPE == 'darwin'* ]] && [[ $(arch) == 'i386' ]]; then
    javac --module-path ./lib/javafx-osx-intel/lib --add-modules javafx.controls,javafx.fxml -cp "./:./bin/:./lib/Java-WebSocket-1.5.3.jar:./lib/slf4j-api-2.0.3.jar:./lib/slf4j-simple-2.0.3.jar:./lib/json-20220924.jar" -d ./bin/ ./src/*.java
    java  -Xdock:icon=./assets/icon.png --module-path ./lib/javafx-osx-intel/lib --add-modules javafx.controls,javafx.fxml -cp "./:./bin/:./lib/Java-WebSocket-1.5.3.jar:./lib/slf4j-api-2.0.3.jar:./lib/slf4j-simple-2.0.3.jar:./lib/json-20220924.jar" Main
fi

#if [[ $OSTYPE == 'darwin'* ]] && [[ $(arch) == 'arm64' ]]; then
#    javac --module-path ./lib/javafx-osx-arm/lib --add-modules javafx.controls,javafx.fxml -cp "./:./bin/:./lib/Java-WebSocket-1.5.3.jar:./lib/slf4j-api-2.0.3.jar:./lib/slf4j-simple-2.0.3.jar:./lib/json-20220924.jar" -d ./bin/ ./src/*.java
#    java -Xdock:icon=./assets/icon.png --module-path ./lib/javafx-osx-arm/lib --add-modules javafx.controls,javafx.fxml  -cp "./:./bin/:./lib/Java-WebSocket-1.5.3.jar:./lib/slf4j-api-2.0.3.jar:./lib/slf4j-simple-2.0.3.jar:./lib/json-20220924.jar" Main
#fi

if [[ $OSTYPE == 'darwin'* ]] && [[ $(arch) == 'arm64' ]]; then
    javac --module-path ./lib/javafx-osx-arm-20/lib --add-modules javafx.controls,javafx.fxml -cp "./:./bin/:./lib/Java-WebSocket-1.5.3.jar:./lib/slf4j-api-2.0.3.jar:./lib/slf4j-simple-2.0.3.jar:./lib/json-20220924.jar" -d ./bin/ ./src/*.java
    java -Xdock:icon=./assets/icon.png --module-path ./lib/javafx-osx-arm-20/lib --add-modules javafx.controls,javafx.fxml  -cp "./:./bin/:./lib/Java-WebSocket-1.5.3.jar:./lib/slf4j-api-2.0.3.jar:./lib/slf4j-simple-2.0.3.jar:./lib/json-20220924.jar" Main
fi