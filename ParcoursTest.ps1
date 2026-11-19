$ErrorActionPreference = 'Stop'
$projectPath = $PSScriptRoot
$enginePath = Join-Path $projectPath 'tools\godot\Godot_v4.4.1-stable_win64.exe'
# A distinct Godot user directory: never loads or writes the normal play save.
if (-not (Test-Path -LiteralPath $enginePath)) { throw 'Moteur Godot local absent dans tools/godot.' }
$env:APPDATA = Join-Path $projectPath 'tools\parcours-test-user'
New-Item -ItemType Directory -Force -Path $env:APPDATA | Out-Null
Start-Process -FilePath $enginePath -ArgumentList @('--path', ('"' + $projectPath + '"'), '--', '--test-route') -WorkingDirectory $projectPath
