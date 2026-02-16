# PowerShell Lab: Bulk Active Directory User Create/Delete (CSV)

This repository archives a BCIT in-class PowerShell lab that performs:
- Bulk **user creation** in Active Directory from a CSV
- Bulk **user deletion** in Active Directory from the same CSV

To keep this repo reusable, the sample data uses placeholder values like `example.local`.
(In my own lab environment, I used `ryohei.lab`.)

## Repo structure
powershell-lab/
data/
bulkusers.csv
scripts/
bulkusers_create.ps1
bulkusers_delete.ps1
.gitignore
README.md


## Requirements
- Windows with **RSAT / ActiveDirectory PowerShell module**
- Permissions to create/delete users in the target OU/container
- A lab AD environment is recommended

## CSV format
File: `data/bulkusers.csv`

Header:
```csv
firstname,lastname,username,password,email,streetaddress,city,state,country,department,telephone,jobtitle,company,ou
Minimum fields:

username
password (required for create)
ou (Distinguished Name, e.g., CN=Users,DC=example,DC=local or OU=Users,DC=example,DC=local)

Placeholder values (intended)
Passwords in the sample CSV are CHANGEME

Domain placeholders use example.local / DC=example,DC=local

If you want to run this in your own lab domain (e.g., ryohei.lab):
Update the create script UPN suffix from example.local to ryohei.lab
Update the CSV ou DN from DC=example,DC=local to DC=ryohei,DC=lab

Important: CSV path setting (before you run)
Both scripts currently use a hardcoded CSV path:

$CSVPath = "C:\powershell-lab\bulkusers.csv"
Choose ONE option:

Option A (no code changes)
Create the folder:
C:\powershell-lab\

Copy the repo CSV to:
C:\powershell-lab\bulkusers.csv

Then run the scripts from anywhere.

Option B (recommended: repo-relative path)
Edit $CSVPath in both scripts to:
$CSVPath = Join-Path $PSScriptRoot "..\data\bulkusers.csv"
Then you can run directly from the repo without copying files.

How to run
Bulk create users
.\scripts\bulkusers_create.ps1
Expected behavior:
If the user already exists (same SamAccountName), it is skipped
Otherwise, the user is created
A summary prints at the end

Bulk delete users (destructive)
.\scripts\bulkusers_delete.ps1
Expected behavior:
If user does not exist, it is skipped

Otherwise, the user is deleted
A summary prints at the end

Safer test run (recommended)
Temporarily add -WhatIf to the delete command in the script:
Remove-ADUser -Identity $Username -WhatIf

What I practiced / learned
Bulk AD automation using Import-Csv, New-ADUser, and Remove-ADUser
Existence checks before create/delete
Working with common user attributes and DN paths (OU/CN)
Tracking results with counters and summaries
