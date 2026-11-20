$ErrorActionPreference = 'Stop'
$projectPath = $PSScriptRoot
$enginePath = Join-Path $projectPath 'tools\godot\Godot_v4.4.1-stable_win64.exe'
if (-not (Test-Path -LiteralPath $enginePath)) { throw 'Moteur Godot local absent dans tools/godot.' }
# This scene never instantiates the campaign or its persistence controller.
$env:APPDATA = Join-Path $projectPath 'tools\team-lab-user'
New-Item -ItemType Directory -Force -Path $env:APPDATA | Out-Null
Start-Process -FilePath $enginePath -ArgumentList @('--path', ('"' + $projectPath + '"'), 'res://visual/team/lab.tscn') -WorkingDirectory $projectPath
