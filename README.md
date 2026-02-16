# PowerShell Lab (BCIT): Bulk AD User Create + Delete (CSV)

This repo contains my BCIT in-class PowerShell lab scripts for **bulk user management in Active Directory** using a CSV file.

## Files
- `bulkusers_create.ps1`  
  Creates AD user accounts from `bulkusers.csv` (skips users that already exist).

- `bulkusers_delete.ps1`  
  Deletes AD user accounts listed in `bulkusers.csv` (skips users that do not exist).

- `bulkusers.csv`  
  Input data source (user attributes + target container DN).

## Requirements
- Windows machine with **RSAT / ActiveDirectory PowerShell module**
- Permissions to create/delete users in the target container (OU/CN)
- Lab domain environment (recommended)

## Important configuration (before you run)
### 1) CSV path in both scripts
Both scripts currently use this hardcoded path:
```powershell
$CSVPath = "C:\powershell-lab\bulkusers.csv"

So either:
Place the folder at C:\powershell-lab\ (recommended for this lab setup), or
Edit $CSVPath in each script to match your local path.

### 2) CSV format
Header used by this lab:
firstname,lastname,username,password,email,streetaddress,city,state,country,department,telephone,jobtitle,company,ou

Minimum needed for the scripts to work correctly:
- username
- password (for create)
- ou (DN path like CN=Users,DC=...,DC=...)
Other fields are optional but supported in bulkusers_create.ps1 (City, Company, Title, etc.).

### 3) How to run
- Bulk create users
# Run from anywhere (CSV path is hardcoded in the script)
.\bulkusers_create.ps1

Expected behavior:
- If a user already exists (SamAccountName matches), it is skipped with a warning.
- If not, the user is created and counted.\
- A summary prints at the end.

- Bulk delete users (destructive)
# Run from anywhere (CSV path is hardcoded in the script)
.\bulkusers_delete.ps1

Expected behavior:

Script checks existence using:

Get-ADUser -LDAPFilter "(sAMAccountName=$Username)"

If user exists, it deletes using:
- Remove-ADUser -Identity $Username -Confirm:$false
- If user does not exist, it is skipped with a warning.
- A summary prints at the end.

Safety notes
bulkusers_delete.ps1 permanently deletes accounts (no recycle bin restore in many lab setups).
If you want a safer test run, temporarily change the delete line to include -WhatIf:

Remove-ADUser -Identity $Username -WhatIf

### What I practiced / learned
Bulk AD automation using Import-Csv, New-ADUser, and Remove-ADUser
Existence checks before create/delete
Working with common user attributes and container DNs (OU/CN)
Tracking results with counters + summaries
