$ErrorActionPreference = 'Stop'
$enginePath = Join-Path $PSScriptRoot 'tools\godot\Godot_v4.4.1-stable_win64.exe'
$env:APPDATA = Join-Path $PSScriptRoot 'tools\play-user'
New-Item -ItemType Directory -Force -Path $env:APPDATA | Out-Null
Start-Process -FilePath $enginePath -ArgumentList @('--path', ('"' + $PSScriptRoot + '"'), 'res://prototypes/lab.tscn') -WorkingDirectory $PSScriptRoot
