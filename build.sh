#!/bin/bash

# Use the 'Project/data' folder for initial data.
# Use the './data' folder for development data (or initial data).
# Use the './Project/assets' folder to add data into the JAR file.

reset

folderDevelopment="Project"
folderRelease="Release"

# Get into the development directory
cd $folderDevelopment

# Check if is JavaFX
isJavaFX=false
if ls lib/javafx* 1> /dev/null 2>&1; then
    isJavaFX=true
    if [[ $OSTYPE == 'linux-gnu' ]]; then
        MODULEPATH=./lib/javafx-linux/lib
    fi
    if [[ $OSTYPE == 'darwin'* ]] && [[ $(arch) == 'i386' ]]; then
        MODULEPATH=./lib/javafx-osx-intel/lib
    fi
    if [[ $OSTYPE == 'darwin'* ]] && [[ $(arch) == 'arm64' ]]; then
        MODULEPATH=./lib/javafx-osx-arm/lib
    fi
    MODULEPATH="--module-path $MODULEPATH --add-modules javafx.controls,javafx.fxml"
fi

# Check if is Hibernate
HIBERNATEX=""
HIBERNATEW=""
if [ -n "$(find . -maxdepth 1 -type f -name 'hibernate.properties' -print -quit)" ]; then
    HIBERNATEX="--add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED"
    HIBERNATEW="--add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --enable-preview -XX:+ShowCodeDetailsInExceptionMessages"
fi

# Remove any existing .class files from the bin directory
rm -rf ./bin

# Create the bin directory if it doesn't exist
mkdir -p ./bin

# Copy the assets directory to the bin directory
if [ -d ./assets ]; then
    cp -r ./assets ./bin
fi
if [ -d ./icons ]; then
    cp -r ./icons ./bin
fi

# Generate the CLASSPATH by iterating over JAR files in the lib directory and its subdirectories
lib_dir="lib"
jar_files=()

# Find all JAR files in the lib directory and its subdirectories
if [ -d ./lib ]; then
    while IFS= read -r -d '' jar_file; do
    if [[ "$jar_file" != *"javafx"* ]]; then
        jar_files+=("$jar_file")
    fi
    done < <(find "$lib_dir" -name "*.jar" -type f -print0)
fi

# Join the JAR files into the class_path
class_path=$(IFS=:; echo "${jar_files[*]}")

# Remove the leading ':' from the class_path
CLASSPATHX=${class_path#:}
if [ -n "$CLASSPATHX" ]; then
    CLASSPATHX="-cp \"$CLASSPATHX\""
fi

# Unir els fitxers JAR en el class_path
class_path_win=$(IFS=";"; printf "%s" "${jar_files[*]}")
class_path_win=$(echo "$class_path_win" | sed 's|lib/|.\\lib\\|g')

# Eliminar el ':' inicial del class_path
CLASSPATHW=${class_path_win#:}
if [ -n "$CLASSPATHW" ]; then
    CLASSPATHW="-cp \"$CLASSPATHW\""
fi

# Compile the Java source files and place the .class files in the bin directory
eval "javac -d ./bin/ ./src/*.java $CLASSPATHX $MODULEPATH"

# Create the Project.jar file with the specified manifest file and the contents of the bin directory
jar cfm ./Project.jar ./Manifest.txt -C bin .

# Remove any .class files from the bin directory
rm -rf ./bin

# Get out of the development directory
cd ..

# Move 'data' temporally
if [ -d "./$folderRelease/data" ]; then
    mv "./$folderRelease/data" ./
fi

# Erase and create $folderRelease
rm -rf ./$folderRelease
mkdir -p ./$folderRelease

# Move 'data' to $folderRelease
if [ -d "./data" ]; then
    mv ./data "./$folderRelease/"
elif [ -d "./$folderDevelopment/data" ]; then
    cp -r ./$folderDevelopment/data "./$folderRelease/"
fi

# Move the Project.jar file to the release directory
mv ./$folderDevelopment/Project.jar ./$folderRelease/Project.jar

# Copy lib if it exists
if [ -d ./$folderDevelopment/lib ]; then
    cp -r ./$folderDevelopment/lib ./$folderRelease/lib
fi

# Copy icons if they exist
if [ -d ./$folderDevelopment/icons ] && [ "$isJavaFX" = true ]; then
    cp -r ./$folderDevelopment/icons ./$folderRelease/icons
fi

# Copy .properties if they exist
if [ -n "$(find ./$folderDevelopment -maxdepth 1 -type f -name '*.properties' -print -quit)" ]; then
    cp -r ./$folderDevelopment/*.properties ./$folderRelease/
fi

# Copy .xml if they exist (for Hibernate)
if [ -n "$(find ./$folderDevelopment -maxdepth 1 -type f -name '*.xml' -print -quit)" ]; then
    cp -r ./$folderDevelopment/*.xml ./$folderRelease/
fi

# Add Project.jar to classpath
CLASSPATHX=${CLASSPATHX/#"-cp \""/}
if [ -n "$CLASSPATHX" ]; then
    CLASSPATHX="-cp \"Project.jar:$CLASSPATHX"
else
    CLASSPATHX="-cp \"Project.jar\""
fi
CLASSPATHW=${CLASSPATHW/#"-cp \""/}
if [ -n "$CLASSPATHW" ]; then
    CLASSPATHW="-cp \"Project.jar;$CLASSPATHW"
else
    CLASSPATHW="-cp \"Project.jar\""
fi

# Create the 'run.sh' and 'run.ps1' files
if [ "$isJavaFX" != true ]; then
cat > ./$folderRelease/run.sh << EOF
#!/bin/bash
java $HIBERNATEX $CLASSPATHX Main
EOF
cat > ./$folderRelease/run.ps1 << EOF
java $HIBERNATEW $CLASSPATHW Main
EOF
else
cat > ./$folderRelease/run.sh << EOF
#!/bin/bash
MODULEPATH=""
ICON=""
if ls lib/javafx* 1> /dev/null 2>&1; then
    if [[ \$OSTYPE == 'linux-gnu' ]]; then
        MODULEPATH=./lib/javafx-linux/lib
    fi
    if [[ \$OSTYPE == 'darwin'* ]] && [[ \$(arch) == 'i386' ]]; then
        MODULEPATH=./lib/javafx-osx-intel/lib
        ICON=-Xdock:icon=icons/iconOSX.png
    fi
    if [[ \$OSTYPE == 'darwin'* ]] && [[ \$(arch) == 'arm64' ]]; then
        MODULEPATH=./lib/javafx-osx-arm/lib
        ICON=-Xdock:icon=icons/iconOSX.png
    fi
    MODULEPATH="--module-path \$MODULEPATH --add-modules javafx.controls,javafx.fxml"
fi
java $HIBERNATEX \$ICON \$MODULEPATH $CLASSPATHX Main
EOF
cat > ./$folderRelease/run.ps1 << EOF
java $HIBERNATEW --module-path "./lib/javafx-windows/lib" --add-modules javafx.controls,javafx.fxml $CLASSPATHW Main
EOF
fi

# Fem l'arxiu executable
chmod +x ./$folderRelease/run.sh

# Run the Project.jar file
cd ./$folderRelease
./run.sh
cd 