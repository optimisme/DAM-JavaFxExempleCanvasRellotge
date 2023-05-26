@echo off

set folderDevelopment=Project
set folderRelease=Release

rem Get into the development directory
cd %folderDevelopment%

rem Remove any existing .class files from the bin directory
rmdir /s /q .\bin

rem Create the bin directory if it doesn't exist
mkdir .\bin

rem Copy the assets directory to the bin directory
xcopy .\assets .\bin /E /I
xcopy .\icons .\bin /E /I

rem Generate the CLASSPATH by iterating over JAR files in the lib directory and its subdirectories
set "lib_dir=lib"
set "jar_files="

rem Find all JAR files in the lib directory and its subdirectories
for /R "%lib_dir%" %%F in (*.jar) do (
    if not "%%~nxF" == "javafx" (
        set "jar_files=!jar_files!;%%F"
    )
)

rem Remove the leading ';' from the jar_files
set "class_path=%jar_files:~1%"

rem Generate MODULEPATH and ICON depending on the OS and architecture
if "%OSTYPE%"=="linux-gnu" (
    set "MODULEPATH=./lib/javafx-linux/lib"
    set "ICON="
)

rem Compile the Java source files and place the .class files in the bin directory
javac -d .\bin .\src\*.java --module-path %MODULEPATH% --add-modules javafx.controls,javafx.fxml

rem Create the Project.jar file with the specified manifest file and the contents of the bin directory
jar cfm .\Project.jar .\Manifest.txt -C bin .

rem Remove any .class files from the bin directory
rmdir /s /q .\bin

rem Get out of the development directory
cd ..

rem Move the Project.jar file to the release directory
rmdir /s /q .\%folderRelease%
mkdir .\%folderRelease%
move .\%folderDevelopment%\Project.jar .\%folderRelease%\Project.jar
xcopy .\%folderDevelopment%\lib .\%folderRelease%\lib /E /I

rem Create the 'run.bat' file
(
    echo @echo off
    echo java %ICON% --module-path %MODULEPATH% --add-modules javafx.controls,javafx.fxml -cp Project.jar;%CLASSPATH% Main
) > .\%folderRelease%\run.bat

rem Run the Project.jar file
cd .\%folderRelease%
call run.bat
cd ..
