# build.ps1
# Full pipeline: sync from toolkit → pack → deploy to BG3 mods folder
# Run this after saving in the BG3 Toolkit. No command line knowledge needed.

$DevRoot   = $PSScriptRoot
$Divine    = "D:\Aaron\development\tools\ExportTool-v1.20.4\Packed\Tools\Divine.exe"
$Staging   = "$DevRoot\build\staging"
$Output    = "$DevRoot\build\TombOfHorrors.pak"
$BG3Data   = "D:\Steam\steamapps\common\Baldurs Gate 3\Data"
$UUID      = "Tomb_of_Horrors_e47b994b-fb66-3bf6-ff90-d0bcd2504e48"
$ModsDir   = "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods"

Write-Host ""
Write-Host "=== Tomb of Horrors Build Pipeline ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Sync from toolkit
Write-Host "[1/4] Syncing from BG3 Toolkit..." -ForegroundColor Yellow
& "$DevRoot\sync-from-toolkit.ps1"

# Step 2: Build staging area
Write-Host "[2/4] Building staging area..." -ForegroundColor Yellow
if (Test-Path $Staging) { Remove-Item $Staging -Recurse -Force }
New-Item -ItemType Directory -Force -Path "$Staging\Mods\$UUID" | Out-Null
New-Item -ItemType Directory -Force -Path "$Staging\Public\$UUID" | Out-Null
robocopy "$BG3Data\Mods\$UUID"   "$Staging\Mods\$UUID"   /MIR /NFL /NDL /NJH /NJS | Out-Null
if (Test-Path "$BG3Data\Public\$UUID") {
    robocopy "$BG3Data\Public\$UUID" "$Staging\Public\$UUID" /MIR /NFL /NDL /NJH /NJS | Out-Null
}
Write-Host "  Done."

# Step 3: Pack
Write-Host "[3/4] Packing mod..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "$DevRoot\build" | Out-Null
& $Divine --action create-package --source $Staging --destination $Output --game bg3
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Packing failed!" -ForegroundColor Red
    exit 1
}
Write-Host "  Done. Output: $Output"

# Step 4: Deploy to BG3 mods folder
Write-Host "[4/4] Deploying to BG3 Mods folder..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $ModsDir | Out-Null
Copy-Item $Output $ModsDir -Force
Write-Host "  Done. Deployed to: $ModsDir"

Write-Host ""
Write-Host "=== Build complete! ===" -ForegroundColor Green
Write-Host "Open BG3 Mod Manager, enable TombOfHorrors, export to game, and launch BG3."
Write-Host ""
