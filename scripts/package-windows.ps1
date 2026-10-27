# Packages a Windows build into a self-contained folder:
#
#   <out>\bin\                 engine-sim-app.exe, delta.conf and DLLs
#   <out>\assets, es, basic    scripts, engines, fonts and shaders
#
# Usage: scripts\package-windows.ps1 <exe path> <SDL bin dir> <output dir>

param(
    [Parameter(Mandatory = $true)][string]$Exe,
    [Parameter(Mandatory = $true)][string]$SdlBinDir,
    [Parameter(Mandatory = $true)][string]$OutDir
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$basic = Join-Path $repo 'dependencies/submodules/delta-studio/engines/basic'

if (Test-Path $OutDir) { Remove-Item -Recurse -Force $OutDir }
New-Item -ItemType Directory -Force (Join-Path $OutDir 'bin'), (Join-Path $OutDir 'basic') | Out-Null
$bin = Join-Path $OutDir 'bin'

Copy-Item $Exe $bin

# D3DX/D3D compiler runtime that delta-studio ships, then SDL and its image
# codecs from the build's own SDL so the DLLs match the import libraries
Copy-Item (Join-Path $repo 'dependencies/submodules/delta-studio/dependencies/runtime/x64/*.dll') $bin
Copy-Item (Join-Path $SdlBinDir '*.dll') $bin -Force

# Engine (fonts/shaders) directory, then the assets directory. LF only: the
# app reads this with std::getline and would keep a trailing CR
[IO.File]::WriteAllText((Join-Path $bin 'delta.conf'), "../basic`n../assets`n")

Copy-Item -Recurse (Join-Path $repo 'assets'), (Join-Path $repo 'es') $OutDir
Copy-Item -Recurse (Join-Path $basic 'fonts'), (Join-Path $basic 'shaders') (Join-Path $OutDir 'basic')
Get-ChildItem -Recurse -Force -Filter .DS_Store $OutDir | Remove-Item -Force
