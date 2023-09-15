# PowerShell script to build the project

# Use the 'Project/data' folder for initial data.
# Use the './data' folder for development data (or initial data).
# Use the './Project/assets' folder to add data into the JAR file.

Clear-Host

$folderDevelopment = "Project"
$folderRelease = "Release"

# Get into the development directory
Set-Location $folderDevelopment

# Check if is JavaFX
$isJavaFX = $false
$MODULEPATH=""
if (Test-Path -Path "lib/javafx*" -ErrorAction SilentlyContinue) {
    $isJavaFX = $true
    $MODULEPATH = "--module-path ./lib/javafx-windows/lib --add-modules javafx.controls,javafx.fxml"
}

# Check if is Hibernate
$HIBERNATEX=""
$HIBERNATEW=""
if (Test-Path ".\hibernate.properties") {
    $HIBERNATEX="--add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED"
    $HIBERNATEW="--add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --enable-preview -XX:+ShowCodeDetailsInExceptionMessages"
}

# Remove any existing .class files from the bin directory
if (Test-Path -Path "./bin") {
    Remove-Item -Recurse -Force -Path "./bin"
}

# Create the bin directory if it doesn't exist
New-Item -ItemType Directory -Force -Path ./bin | Out-Null

# Copy the assets directory to the bin directory
if (Test-Path -Path "./assets") {
    Copy-Item -Recurse -Force ./assets ./bin/assets
}

# Copy the icons if they exist
if (Test-Path -Path "./icons") {
    Copy-Item -Recurse -Force ./icons ./bin/icons
}

# Generate the CLASSPATHW by iterating over JAR files in the lib directory and its subdirectories
$jar_files = @()
if (Test-Path -Path "./lib") {
    $lib_dir = (Resolve-Path "lib").Path
    $jar_files = Get-ChildItem -Path $lib_dir -Filter "*.jar" -Recurse | ForEach-Object {
        if (-not $_.Name.Contains("javafx")) {
            ".\lib\" + $_.FullName.Replace($lib_dir + '\', '')
        }
    }
}

# Enclose paths with quotes if they contain spaces
$CLASSPATHW = ($jar_files | ForEach-Object { 
    if($_ -match '\s') {
        "`"" + $_ + "`""
    } else {
        $_
    } 
}) -join ';'
if ($CLASSPATHW) {
    $CLASSPATHW = "-cp `"" + $CLASSPATHW + "`""
}

# Generate the CLASSPATHX for UNIX
$jar_files = @()
if (Test-Path -Path "./lib") {
    $lib_dir = (Resolve-Path "lib").Path
    if (-not $isJavaFX) {
        $jar_files = Get-ChildItem -Path $lib_dir -Filter "*.jar" -Recurse | ForEach-Object { "lib/" + $_.FullName.Replace($lib_dir + '\', '') }
    } else {
        $jar_files = Get-ChildItem -Path $lib_dir -Filter "*.jar" -Recurse | ForEach-Object {
            if (-not $_.Name.Contains("javafx")) {
                "lib/" + $_.FullName.Replace($lib_dir + '\', '')
            }
        }
    }
}

# Enclose paths with quotes if they contain spaces
$CLASSPATHX = ($jar_files | ForEach-Object { 
    if($_ -match '\s') {
        "`"" + $_ + "`""
    } else {
        $_
    } 
}) -join ':'
if ($CLASSPATHX) {
    $CLASSPATHX = "-cp `"" + $CLASSPATHX + "`""
}

# Compile the Java source files and place the .class files in the bin directory
$javacCommand = "javac -d ./bin/ ./src/*.java $CLASSPATHW $MODULEPATH"
Invoke-Expression $javacCommand

# Create the Project.jar file with the specified manifest file and the contents of the bin directory
if (Get-Command jar -ErrorAction SilentlyContinue) {
    # jar command is available, use it
    jar cfm ./Project.jar ./Manifest.txt -C bin .
} else {
    # jar command is not available, try to find it
    $jarExePath = Get-ChildItem -Path C:\ -Recurse -Filter "jar.exe" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
    if ($jarExePath) {
        & $jarExePath cfm ./Project.jar ./Manifest.txt -C bin .
    } else {
        Write-Host "Jar command not found."
    }
}

# Remove any .class files from the bin directory
Remove-Item -Recurse -Force ./bin

# Get out of the development directory
Set-Location ..

# Move 'data' temporally
if (Test-Path -Path "./$folderRelease/data") {
    Move-Item -Path "./$folderRelease/data" -Destination "./data"
}

# Erase and create $folderRelease
if (Test-Path -Path "./$folderRelease") {
    Remove-Item -Recurse -Force "./$folderRelease"
}
New-Item -ItemType Directory -Force -Path "./$folderRelease" | Out-Null

# Move 'data' to $folderRelease
if (Test-Path -Path "./data") {
    Copy -Path "./data" -Destination "./$folderRelease/data"
}
elseif (Test-Path -Path "./$folderDevelopment/data") {
    Copy-Item -Path "./$folderDevelopment/data" -Destination "./$folderRelease/" -Recurse
}

# Move the Project.jar file to the release directory
Move-Item ./$folderDevelopment/Project.jar ./$folderRelease/Project.jar

if (Test-Path -Path "./$folderDevelopment/lib") {
    Copy-Item -Recurse -Force "./$folderDevelopment/lib" "./$folderRelease/lib"
}

if ((Test-Path -Path ".\$folderDevelopment\icons") -and $isJavaFX) {
    Copy-Item -Path ".\$folderDevelopment\icons" -Destination ".\$folderRelease\icons" -Recurse
}

# Copy .properties if they exist
if (Test-Path -Path ".\$folderDevelopment\*.properties" -PathType Leaf) {
    Copy-Item -Path ".\$folderDevelopment\*.properties" -Destination ".\$folderRelease\" -Force
}

# Copy .xml if they exist (for hibernate)
if (Test-Path -Path ".\$folderDevelopment\*.xml" -PathType Leaf) {
    Copy-Item -Path ".\$folderDevelopment\*.xml" -Destination ".\$folderRelease\" -Force
}

# Add Project.jar to classpath
$CLASSPATHX = $CLASSPATHX -replace "-cp `"", ""
if ($CLASSPATHX) {
    $CLASSPATHX = "-cp `"Project.jar:$CLASSPATHX"
} else {
    $CLASSPATHX = "-cp `"Project.jar`""
}
$CLASSPATHW = $CLASSPATHW -replace "-cp `"", ""
if ($CLASSPATHW) {
    $CLASSPATHW = "-cp `"Project.jar;$CLASSPATHW"
} else {
    $CLASSPATHW = "-cp `"Project.jar`""
}

# Create the 'run.sh' and 'run.ps1' files
if (-not $isJavaFX) {
@"
#!/bin/bash
java $HIBERNATEX $CLASSPATHX Main
"@ | Out-File -FilePath ".\$folderRelease\run.sh" -Encoding UTF8
@"
java $HIBERNATEW $CLASSPATHW Main
"@ | Out-File -FilePath ".\$folderRelease\run.ps1" -Encoding UTF8
} else {
@"
#!/bin/bash
MODULEPATH=""
ICON=""
if ls lib/javafx* 1> /dev/null 2>&1; then
    if [[ `$OSTYPE == 'linux-gnu' ]]; then
        MODULEPATH=./lib/javafx-linux/lib
    fi
    if [[ `$OSTYPE == 'darwin'* ]] && [[ `$(arch) == 'i386' ]]; then
        MODULEPATH=./lib/javafx-osx-intel/lib
        ICON=-Xdock:icon=icons/iconOSX.png
    fi
    if [[ `$OSTYPE == 'darwin'* ]] && [[ `$(arch) == 'arm64' ]]; then
        MODULEPATH=./lib/javafx-osx-arm/lib
        ICON=-Xdock:icon=icons/iconOSX.png
    fi
    MODULEPATH="--module-path `$MODULEPATH --add-modules javafx.controls,javafx.fxml"
fi
java $HIBERNATEX `$ICON `$MODULEPATH $CLASSPATHX Main
"@ | Out-File -FilePath ".\$folderRelease\run.sh" -Encoding UTF8
@"
java $HIBERNATEW $MODULEPATH $CLASSPATHW Main
"@ | Out-File -FilePath ".\$folderRelease\run.ps1" -Encoding UTF8
}

# Run the Project.jar file
Set-Location ./$folderRelease
./run.ps1
Set-Location ..