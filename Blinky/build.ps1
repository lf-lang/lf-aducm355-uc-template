# This PowerShell3 script will run the Lingua Franca Compiler (LFC)
# on the file specified in $MAIN. It is meant to be invoked pre-build
# by Keil uVision 5.


# This script will compile the file found at src/$MAIN.lf
$MAIN="Blinky"

try {
    $LF_MAIN=Join-Path -Path $PSScriptRoot -ChildPath "src\$MAIN.lf"
    $LFC = Join-Path -Path $Env:REACTOR_UC_PATH -ChildPath "lfc\bin\lfc-dev.ps1"

    if (-not $Env:REACTOR_UC_PATH) {
        throw "Environment variable REACTOR_UC_PATH not set"
    }
    Write-Host "Running command $LFC $LF_MAIN"
    & $LFC $LF_MAIN
}
catch {
    Write-Error "Error occurred during code-generation: $_"
    exit
}

