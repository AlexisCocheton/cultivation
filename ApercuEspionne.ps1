$ErrorActionPreference = 'Stop'
$projectPath = $PSScriptRoot
$enginePath = Join-Path $projectPath 'tools\godot\Godot_v4.4.1-stable_win64.exe'
if (-not (Test-Path -LiteralPath $enginePath)) { throw 'Moteur Godot local absent dans tools/godot.' }
# Profil isolé, et --script désactive toute persistance du jeu.
$env:APPDATA = Join-Path $projectPath 'tools\spy-preview-user'
New-Item -ItemType Directory -Force -Path $env:APPDATA | Out-Null
Start-Process -FilePath $enginePath -ArgumentList @('--path', ('"' + $projectPath + '"'), '--script', 'res://tests/preview_spy_arrival.gd') -WorkingDirectory $projectPath
