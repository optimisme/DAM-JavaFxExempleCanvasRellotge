#!/bin/bash

reset

export folderDevelopment="Project"
export folderRelease="Release"

# Get into the development directory
cd $folderDevelopment

# Remove any existing .class files from the bin directory
rm -rf ./bin

# Create the bin directory if it doesn't exist
mkdir -p ./bin

# Copy the assets directory to the bin directory
cp -r ./assets ./bin
cp -r ./icons ./bin

# Generate the CLASSPATH by iterating over JAR files in the lib directory and its subdirectories
lib_dir="lib"
jar_files=()

# Find all JAR files in the lib directory and its subdirectories
while IFS= read -r -d '' jar_file; do
  if [[ "$jar_file" != *"javafx"* ]]; then
    jar_files+=("$jar_file")
  fi
done < <(find "$lib_dir" -name "*.jar" -type f -print0)

# Join the JAR files into the class_path
class_path=$(IFS=:; echo "${jar_files[*]}")

# Remove the leading ':' from the class_path
export CLASSPATH=${class_path#:}

# Generate MODULEPATH and ICON deppending on the OS and architecture
if [[ $OSTYPE == 'linux-gnu' ]]; then
    export MODULEPATH=./lib/javafx-linux/lib
    export ICON=""
fi

if [[ $OSTYPE == 'darwin'* ]] && [[ $(arch) == 'i386' ]]; then
    export MODULEPATH=./lib/javafx-osx-intel/lib
    export ICON=-Xdock:icon=icons/iconOSX.png
fi

if [[ $OSTYPE == 'darwin'* ]] && [[ $(arch) == 'arm64' ]]; then
    export MODULEPATH=./lib/javafx-osx-arm/lib
    export ICON=-Xdock:icon=iconOSX.png
fi

# Compile the Java source files and place the .class files in the bin directory
javac -d ./bin/ ./src/*.java --module-path $MODULEPATH --add-modules javafx.controls,javafx.fxml

# Create the Project.jar file with the specified manifest file and the contents of the bin directory
jar cfm ./Project.jar ./Manifest.txt -C bin .

# Remove any .class files from the bin directory
rm -rf ./bin

# Get out of the development directory
cd ..

# Move the Project.jar file to the release directory
rm -rf ./$folderRelease
mkdir -p ./$folderRelease
mv ./$folderDevelopment/Project.jar ./$folderRelease/Project.jar
cp -r ./$folderDevelopment/lib ./$folderRelease/lib

# If OSX copy the icon to the release directory
if [[ $OSTYPE == 'darwin'* ]]; then
    cp -r ./$folderDevelopment/icons/iconOSX.png ./$folderRelease/iconOSX.png
fi

# Create the 'run.sh' file
cat > run.sh << EOF
#!/bin/bash

java $ICON --module-path $MODULEPATH --add-modules javafx.controls,javafx.fxml -cp Project.jar:$CLASSPATH Main

EOF

# Fem l'arxiu executable
chmod +x run.sh
mv run.sh ./$folderRelease/run.sh

# Run the Project.jar file
cd ./$folderRelease
./run.sh
cd ..