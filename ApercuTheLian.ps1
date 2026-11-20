$ErrorActionPreference = 'Stop'
$projectPath = $PSScriptRoot
$env:APPDATA = Join-Path $projectPath 'tools\tea-preview-user'
$enginePath = Join-Path $projectPath 'tools\godot\Godot_v4.4.1-stable_win64.exe'
Start-Process -FilePath $enginePath -ArgumentList @('--path', ('"' + $projectPath + '"'), 'res://visual/study/tea_preview.tscn') -WorkingDirectory $projectPath
