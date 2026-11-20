$ErrorActionPreference = 'Stop'
$projectPath = $PSScriptRoot
$enginePath = Join-Path $projectPath 'tools\godot\Godot_v4.4.1-stable_win64.exe'
if (-not (Test-Path -LiteralPath $enginePath)) { throw 'Moteur Godot local absent.' }
$env:APPDATA = Join-Path $projectPath 'tools\relations-route-user'
New-Item -ItemType Directory -Force -Path $env:APPDATA | Out-Null
$game = Start-Process -FilePath $enginePath -ArgumentList @('--path', ('"' + $projectPath + '"'), '--', '--story-route') -WorkingDirectory $projectPath -PassThru
Wait-Process -Id $game.Id
