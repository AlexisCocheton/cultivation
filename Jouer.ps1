$ErrorActionPreference = 'Stop'
$projectPath = $PSScriptRoot
$enginePath = Join-Path $projectPath 'tools\godot\Godot_v4.4.1-stable_win64.exe'
if (-not (Test-Path -LiteralPath $enginePath)) {
    throw 'Moteur local absent. Ouvrez project.godot dans Godot 4.4 ou plus récent, puis appuyez sur F6 ou F5.'
}
$env:APPDATA = Join-Path $projectPath 'tools\play-user'
New-Item -ItemType Directory -Force -Path $env:APPDATA | Out-Null
Start-Process -FilePath $enginePath -ArgumentList @('--path', ('"' + $projectPath + '"')) -WorkingDirectory $projectPath
