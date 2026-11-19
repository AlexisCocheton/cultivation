$ErrorActionPreference = 'Stop'
$projectPath = $PSScriptRoot
$enginePath = Join-Path $projectPath 'tools\godot\Godot_v4.4.1-stable_win64.exe'
$env:APPDATA = Join-Path $projectPath 'tools\play-user'
New-Item -ItemType Directory -Force -Path $env:APPDATA | Out-Null
Start-Process -FilePath $enginePath -ArgumentList @('--path', ('"' + $projectPath + '"'), 'res://visual/spriteforge_compare.tscn') -WorkingDirectory $projectPath
