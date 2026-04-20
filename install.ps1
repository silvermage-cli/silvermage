#Requires -Version 5.1
<#
.SYNOPSIS
    Silvermage installer for Windows.

.DESCRIPTION
    Downloads the latest Silvermage release for Windows x86_64, verifies the
    SHA256 checksum, extracts the binary, and installs it to the per-user
    Programs directory.

.EXAMPLE
    iwr -useb https://raw.githubusercontent.com/silvermage-cli/silvermage/main/install.ps1 | iex

.PARAMETER Version
    Release tag to install (default: latest).

.PARAMETER InstallDir
    Override install directory. Defaults to
    "$env:LOCALAPPDATA\Programs\silvermage".

.PARAMETER NoVerify
    Skip SHA256 verification (not recommended).
#>

[CmdletBinding()]
param(
    [string]$Version = 'latest',
    [string]$InstallDir,
    [switch]$NoVerify
)

$ErrorActionPreference = 'Stop'

$Repo   = 'silvermage-cli/silvermage'
$Bin    = 'silvermage.exe'
$Target = 'x86_64-pc-windows-msvc'

if (-not $InstallDir) {
    $InstallDir = Join-Path $env:LOCALAPPDATA 'Programs\silvermage'
}

function Say([string]$msg)  { Write-Host "[silvermage] $msg" }
function Die([string]$msg)  { Write-Host "[silvermage] error: $msg" -ForegroundColor Red; exit 1 }

# --- URL construction --------------------------------------------------------

if ($Version -eq 'latest') {
    $base = "https://github.com/$Repo/releases/latest/download"
} else {
    $base = "https://github.com/$Repo/releases/download/$Version"
}

$archive = "silvermage-$Target.zip"
$assetUrl = "$base/$archive"
$shaUrl   = "$assetUrl.sha256"

Say "target:   $Target"
Say "version:  $Version"
Say "dest:     $InstallDir\$Bin"

# --- download ----------------------------------------------------------------

$tmp = Join-Path ([IO.Path]::GetTempPath()) ("silvermage-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tmp -Force | Out-Null

try {
    $zipPath = Join-Path $tmp $archive
    $shaPath = "$zipPath.sha256"

    Say "downloading $archive"
    try {
        Invoke-WebRequest -Uri $assetUrl -OutFile $zipPath -UseBasicParsing
    } catch {
        Die "download failed: $($_.Exception.Message)"
    }

    if (-not $NoVerify) {
        Say 'verifying checksum'
        try {
            Invoke-WebRequest -Uri $shaUrl -OutFile $shaPath -UseBasicParsing
        } catch {
            Die "checksum download failed: $($_.Exception.Message)"
        }
        $expected = ((Get-Content $shaPath -Raw) -split '\s+')[0].Trim().ToLowerInvariant()
        $actual   = (Get-FileHash -Path $zipPath -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($expected -ne $actual) {
            Die "checksum mismatch (expected $expected, got $actual)"
        }
    } else {
        Say 'NoVerify set — skipping checksum (not recommended)'
    }

    Say 'extracting'
    $extractDir = Join-Path $tmp 'extract'
    Expand-Archive -Path $zipPath -DestinationPath $extractDir -Force

    $binSrc = Get-ChildItem -Path $extractDir -Recurse -Filter $Bin -File | Select-Object -First 1
    if (-not $binSrc) {
        Die "binary '$Bin' not found inside archive"
    }

    if (-not (Test-Path $InstallDir)) {
        New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    }

    $destPath = Join-Path $InstallDir $Bin
    Copy-Item -Path $binSrc.FullName -Destination $destPath -Force

    # Shorter command aliases. Windows symlinks would require an admin
    # token on most configurations, so we ship file copies instead —
    # tiny disk cost (~31 MB each stripped binary × 3) in exchange for
    # a no-prompt install.
    foreach ($aliasName in @('silver.exe', 'silv.exe', 'sm.exe')) {
        $aliasPath = Join-Path $InstallDir $aliasName
        Copy-Item -Path $destPath -Destination $aliasPath -Force
    }

    Say "installed: $destPath (aliases: silver, silv, sm)"

    # --- PATH hint -----------------------------------------------------------

    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    if ($userPath -notlike "*$InstallDir*") {
        Write-Host ''
        Say "note: $InstallDir is not on your user PATH"
        Say '      add it with:'
        Write-Host ''
        Write-Host "        [Environment]::SetEnvironmentVariable('Path', `"$InstallDir;`" + [Environment]::GetEnvironmentVariable('Path', 'User'), 'User')" -ForegroundColor Yellow
        Write-Host ''
        Say '      then restart your shell.'
    }

    Say "run 'silvermage --help' to get started"
}
finally {
    Remove-Item -Path $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
