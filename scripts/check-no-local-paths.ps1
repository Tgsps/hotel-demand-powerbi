# check-no-local-paths.ps1 (task P0-03)
# Fails if a tracked text file contains a drive-letter path, a user-profile
# folder name, an email-like string, or a UTF-8 byte-order mark.
# Run from anywhere inside the repository.

$ErrorActionPreference = 'Stop'

$root = (git rev-parse --show-toplevel).Trim()
Set-Location $root

$self = 'scripts/check-no-local-paths.ps1'
$skipExt = @('.png', '.jpg', '.jpeg', '.gif', '.pdf', '.pbix', '.abf', '.zip')

$patterns = [ordered]@{
    'drive-letter path'    = '(?<![A-Za-z0-9])[A-Za-z]:[\\/]'
    'user-profile folder'  = '(?i)[\\/]Users[\\/]|[\\/]home[\\/][a-z]|AppData'
    'email-like string'    = '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
}

$findings = @()

foreach ($file in (git ls-files)) {
    if ($file -eq $self) { continue }
    if ($skipExt -contains ([System.IO.Path]::GetExtension($file).ToLower())) { continue }

    $bytes = [System.IO.File]::ReadAllBytes((Join-Path $root $file))
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        $findings += "${file}: UTF-8 byte-order mark"
    }

    $lineNo = 0
    foreach ($line in [System.IO.File]::ReadAllLines((Join-Path $root $file))) {
        $lineNo++
        foreach ($name in $patterns.Keys) {
            $found = [regex]::Matches($line, $patterns[$name])
            foreach ($m in $found) {
                # Public GitHub noreply addresses are allowed.
                if ($name -eq 'email-like string' -and $m.Value -like '*@users.noreply.github.com') { continue }
                $findings += "${file}:${lineNo}: $name"
            }
        }
    }
}

if ($findings.Count -gt 0) {
    Write-Host "FAIL: $($findings.Count) finding(s). Matched text is not printed." -ForegroundColor Red
    $findings | ForEach-Object { Write-Host "  $_" }
    exit 1
}

Write-Host 'PASS: no local paths, emails or byte-order marks in tracked text files.' -ForegroundColor Green
exit 0
