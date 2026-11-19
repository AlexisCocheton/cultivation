$ErrorActionPreference = 'Stop'
$projectPath = $PSScriptRoot
$enginePath = Join-Path $projectPath 'tools\godot\Godot_v4.4.1-stable_win64.exe'
# A distinct Godot user directory: never loads or writes the normal play save.
$env:APPDATA = Join-Path $projectPath 'tools\parcours-test-user'
New-Item -ItemType Directory -Force -Path $env:APPDATA | Out-Null
Start-Process -FilePath $enginePath -ArgumentList @('--path', ('"' + $projectPath + '"'), 'res://visual/preview.tscn', '--', '--test-route') -WorkingDirectory $projectPath
