# sync-to-toolkit.ps1
# Copies files FROM this git repo INTO the BG3 toolkit project directory.
# Run this after cloning the repo on a new machine, or to restore toolkit files.

$BG3Data   = "D:\Steam\steamapps\common\Baldurs Gate 3\Data"
$DevRoot   = $PSScriptRoot
$UUID      = "Tomb_of_Horrors_e47b994b-fb66-3bf6-ff90-d0bcd2504e48"

$sources = @(
    @{ From = "$DevRoot\Mods\Tomb_of_Horrors";     To = "$BG3Data\Mods\$UUID" },
    @{ From = "$DevRoot\Public\Tomb_of_Horrors";   To = "$BG3Data\Public\$UUID" },
    @{ From = "$DevRoot\Projects\Tomb_of_Horrors"; To = "$BG3Data\Projects\$UUID" }
)

foreach ($s in $sources) {
    if (Test-Path $s.From) {
        Write-Host "Syncing $($s.From) -> $($s.To)"
        New-Item -ItemType Directory -Force -Path $s.To | Out-Null
        robocopy $s.From $s.To /MIR /NFL /NDL /NJH /NJS | Out-Null
        Write-Host "  Done."
    } else {
        Write-Host "WARNING: Source not found: $($s.From)"
    }
}

Write-Host ""
Write-Host "Sync complete. Toolkit project files are ready."
