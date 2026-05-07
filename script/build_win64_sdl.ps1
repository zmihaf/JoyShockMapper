param(
    [string]$Configuration = "Release"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$buildDir = Join-Path $repoRoot "build-jsm-win64-sdl"
$installDir = Join-Path $repoRoot "install"
$zipPath = Join-Path $repoRoot "JoyShockMapper_x64.zip"

cmake -S $repoRoot -B $buildDir -A x64 -DBUILD_SHARED_LIBS=1 -DSDL=1
cmake --build $buildDir --config $Configuration
cmake --install $buildDir --config $Configuration --prefix $installDir

if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Compress-Archive `
    -Path (Join-Path $installDir "JoyShockMapper_SDL2_x64") `
    -DestinationPath $zipPath

Write-Host "Built package: $zipPath"
