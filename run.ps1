# run.ps1
function Get-LatestVersion {
    param (
        [string]$moduleName
    )

    # Find the JAR files and sort them by version while excluding javadoc and sources
    $jarFiles = Get-ChildItem -Path "$env:USERPROFILE\.m2\repository\org\openjfx" -Recurse -File |
                Where-Object { $_.Name -like "${moduleName}-*.jar" -and $_.Name -notmatch "(javadoc|sources)" } |
                Sort-Object Name -Descending

    # Return the latest version's path
    if ($jarFiles.Count -gt 0) {
        return $jarFiles[0].FullName
    } else {
        return $null
    }
}

$fxBasePath = Get-LatestVersion "javafx-base"
$fxControlsPath = Get-LatestVersion "javafx-controls"
$fxFxmlPath = Get-LatestVersion "javafx-fxml"
$fxGraphicsPath = Get-LatestVersion "javafx-graphics"

$fxPath = "$fxBasePath;$fxControlsPath;$fxFxmlPath;$fxGraphicsPath"

if (-not $fxPath) {
    Write-Host "No es pot trobar el mòdul JavaFX al repositori Maven local."
    exit 1
}

# Opcions comunes per a MAVEN_OPTS
$env:MAVEN_OPTS = "--add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.nio=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED --module-path $fxPath --add-modules javafx.controls,javafx.fxml,javafx.graphics"

# Resta de l'script

# Check for the first argument and set it as the main class
$mainClass = $args[0]

Write-Output "Setting MAVEN_OPTS to: $MAVEN_OPTS"
Write-Output "Main Class: $mainClass"

# Split the execArg into an array
$javafx_platform = "win"
$execArgs = @("-PrunMain", "-Dexec.mainClass=$mainClass", "-Djavafx.platform=$javafx_platform")

Write-Output "Exec args: $($execArgs -join ' ')"

# Execute mvn command
mvn clean test-compile exec:java $execArgs
