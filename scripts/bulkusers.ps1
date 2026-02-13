<#
.SYNOPSIS
  Bulk-create Active Directory users from a CSV file.

.NOTES
  - Designed for lab/portfolio use.
  - For public GitHub: commit only bulkusers.template.csv (no real passwords).
  - Requires RSAT / ActiveDirectory module.
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    # Default: powershell-lab\data\bulkusers.template.csv
    [Parameter(Mandatory = $false)]
    [string]$CsvPath = (Join-Path $PSScriptRoot "..\data\bulkusers.template.csv"),

    # e.g. "yourdomain.com"
    [Parameter(Mandatory = $false)]
    [string]$UpnSuffix = "example.local",

    # Safer than storing passwords in CSV (SecureString)
    [Parameter(Mandatory = $false)]
    [SecureString]$DefaultPassword,

    # Optional: force password change at next logon
    [Parameter(Mandatory = $false)]
    [switch]$ChangePasswordAtLogon
)

try {
    Import-Module ActiveDirectory -ErrorAction Stop
} catch {
    throw "ActiveDirectory module not found. Install RSAT (Active Directory) and try again. Error: $($_.Exception.Message)"
}

# Load CSV
try {
    $resolvedCsv = Resolve-Path -Path $CsvPath -ErrorAction Stop
    $ADUsers = Import-Csv -Path $resolvedCsv -ErrorAction Stop
} catch {
    throw "Failed to read CSV at '$CsvPath'. Error: $($_.Exception.Message)"
}

# Counters
$CreatedUsers  = 0
$ExistingUsers = 0
$FailedUsers   = 0

foreach ($User in $ADUsers) {

    # Basic fields (safe trimming)
    $Username  = ($User.username  -as [string])
    $Firstname = ($User.firstname -as [string])
    $Lastname  = ($User.lastname  -as [string])
    $OU        = ($User.ou        -as [string])

    $Username  = if ($Username)  { $Username.Trim() }  else { "" }
    $Firstname = if ($Firstname) { $Firstname.Trim() } else { "" }
    $Lastname  = if ($Lastname)  { $Lastname.Trim() }  else { "" }
    $OU        = if ($OU)        { $OU.Trim() }        else { "" }

    if ([string]::IsNullOrWhiteSpace($Username)) {
        continue
    }

    if ([string]::IsNullOrWhiteSpace($OU)) {
        Write-Warning "Skipping '$Username' because 'ou' is empty in CSV."
        $FailedUsers++
        continue
    }

    # Determine password:
    # - If CSV has a password and it's not CHANGEME, use it
    # - Else use -DefaultPassword if provided
    $passwordSecure = $null
    $csvPassword = ($User.password -as [string])
    $csvPassword = if ($csvPassword) { $csvPassword.Trim() } else { "" }

    if (-not [string]::IsNullOrWhiteSpace($csvPassword) -and $csvPassword -ne "CHANGEME") {
        $passwordSecure = ConvertTo-SecureString $csvPassword -AsPlainText -Force
    } elseif ($DefaultPassword) {
        $passwordSecure = $DefaultPassword
    } else {
        Write-Warning "Skipping '$Username' because no password was provided. Use CSV password (not CHANGEME) or -DefaultPassword."
        $FailedUsers++
        continue
    }

    # Check if user exists
    $existing = Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "Exists (skipped): $Username" -ForegroundColor Yellow
        $ExistingUsers++
        continue
    }

    # Build parameters (only add optional fields if present)
    $params = @{
        SamAccountName     = $Username
        UserPrincipalName  = "$Username@$UpnSuffix"
        Name               = ("$Firstname $Lastname").Trim()
        GivenName          = $Firstname
        Surname            = $Lastname
        DisplayName        = ("$Lastname, $Firstname").Trim(", ")
        Enabled            = $true
        Path               = $OU
        AccountPassword    = $passwordSecure
        ErrorAction        = "Stop"
    }

    # Optional attributes from CSV (safe)
    if ($User.email)         { $params.EmailAddress   = ($User.email -as [string]).Trim() }
    if ($User.streetaddress) { $params.StreetAddress  = ($User.streetaddress -as [string]).Trim() }
    if ($User.city)          { $params.City           = ($User.city -as [string]).Trim() }
    if ($User.state)         { $params.State          = ($User.state -as [string]).Trim() }
    if ($User.country)       { $params.Country        = ($User.country -as [string]).Trim() }
    if ($User.telephone)     { $params.OfficePhone    = ($User.telephone -as [string]).Trim() }
    if ($User.jobtitle)      { $params.Title          = ($User.jobtitle -as [string]).Trim() }
    if ($User.company)       { $params.Company        = ($User.company -as [string]).Trim() }
    if ($User.department)    { $params.Department     = ($User.department -as [string]).Trim() }

    if ($ChangePasswordAtLogon) {
        $params.ChangePasswordAtLogon = $true
    }

    try {
        if ($PSCmdlet.ShouldProcess($Username, "Create AD user in OU '$OU'")) {
            New-ADUser @params
            Write-Host "Created: $Username" -ForegroundColor Green
            $CreatedUsers++
        }
    } catch {
        Write-Error "Failed to create '$Username'. Error: $($_.Exception.Message)"
        $FailedUsers++
    }
}

Write-Host "`nBulk user creation completed:" -ForegroundColor Cyan
Write-Host "Created:  $CreatedUsers" -ForegroundColor Green
Write-Host "Skipped (exists): $ExistingUsers" -ForegroundColor Yellow
Write-Host "Failed:   $FailedUsers" -ForegroundColor Red

