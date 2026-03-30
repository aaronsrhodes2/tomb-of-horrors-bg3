# sync-from-toolkit.ps1
# Copies the live toolkit project files into this git repo.
# Run this AFTER making edits in the BG3 Toolkit, before committing.

$BG3Data   = "D:\Steam\steamapps\common\Baldurs Gate 3\Data"
$DevRoot   = $PSScriptRoot
$UUID      = "Tomb_of_Horrors_e47b994b-fb66-3bf6-ff90-d0bcd2504e48"

$sources = @(
    @{ From = "$BG3Data\Mods\$UUID";     To = "$DevRoot\Mods\Tomb_of_Horrors" },
    @{ From = "$BG3Data\Public\$UUID";   To = "$DevRoot\Public\Tomb_of_Horrors" },
    @{ From = "$BG3Data\Projects\$UUID"; To = "$DevRoot\Projects\Tomb_of_Horrors" }
)

foreach ($s in $sources) {
    if (Test-Path $s.From) {
        Write-Host "Syncing $($s.From) -> $($s.To)"
        robocopy $s.From $s.To /MIR /NFL /NDL /NJH /NJS | Out-Null
        Write-Host "  Done."
    } else {
        Write-Host "WARNING: Source not found: $($s.From)"
    }
}

Write-Host ""
Write-Host "Sync complete. Review changes with: git diff"
Write-Host "Then commit with:                   git add -A && git commit -m 'your message'"
