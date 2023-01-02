#!/bin/bash

# Comprimir amb: folder=`basename "$PWD"` && zip -r ../$folder.zip . -x '**/.*' -x '**/__MACOSX' -x '*.zip'

reset
rm -f ./bin/*.* 
mkdir -p ./bin
cp -r ./assets ./bin

if [[ $OSTYPE == 'linux-gnu' ]]; then
    javac --module-path ./lib/javafx-linux/lib --add-modules javafx.controls,javafx.fxml -d ./bin/ ./src/*.java
    java  --module-path ./lib/javafx-linux/lib --add-modules javafx.controls,javafx.fxml -cp "./:./bin/" Main
fi

if [[ $OSTYPE == 'darwin'* ]] && [[ $(arch) == 'i386' ]]; then
    javac --module-path ./lib/javafx-osx-intel/lib --add-modules javafx.controls,javafx.fxml -d ./bin/ ./src/*.java
    java  -Xdock:icon=./assets/icon.png --module-path ./lib/javafx-osx-intel/lib --add-modules javafx.controls,javafx.fxml -cp "./:./bin/" Main
fi

if [[ $OSTYPE == 'darwin'* ]] && [[ $(arch) == 'arm64' ]]; then
    javac --module-path ./lib/javafx-osx-arm/lib --add-modules javafx.controls,javafx.fxml -d ./bin/ ./src/*.java
    java -Xdock:icon=./assets/icon.png --module-path ./lib/javafx-osx-arm/lib --add-modules javafx.controls,javafx.fxml -cp "./:./bin/" Main
fi