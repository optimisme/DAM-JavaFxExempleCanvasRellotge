rem run with: .\run.bat

cls
del /F /Q .\bin\*.*
xcopy .\assets .\bin\assets /E /I /Y

javac --module-path .\lib\javafx-windows\lib --add-modules javafx.controls,javafx.fxml -d .\bin\ .\src\*.java
java  --module-path .\lib\javafx-windows\lib --add-modules javafx.controls,javafx.fxml -cp ".;.\\bin;.\\bin" Main