# PowerShell Lab: Bulk Active Directory User Create/Delete (CSV)

This repository archives a BCIT in-class PowerShell lab that performs:
- Bulk **user creation** in Active Directory from a CSV
- Bulk **user deletion** in Active Directory from a CSV

To keep this repo reusable and safe for public sharing, the sample data uses placeholders like `example.local`
and a template CSV (`bulkusers.template.csv`).

## Repo structure
powershell-lab/
data/
bulkusers.template.csv
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
File: `data/bulkusers.template.csv`

Header:
```csv
firstname,lastname,username,password,email,streetaddress,city,state,country,department,telephone,jobtitle,company,ou

Minimum fields:
- username
- password (required for create)
- ou (Distinguished Name, e.g., CN=Users,DC=example,DC=local or OU=Users,DC=example,DC=local)

Placeholder values (intended)
Passwords in the template CSV use CHANGEME
Domain placeholders use example.local / DC=example,DC=local

If you want to run this in your own lab domain (e.g., ryohei.lab), update:
the create script UPN suffix from example.local to your domain
the CSV ou DN from DC=example,DC=local to your domain DN

CSV path setting (how the scripts locate the file)
Both scripts read the template CSV from this repo path:
$CSVPath = Join-Path $PSScriptRoot "..\data\bulkusers.template.csv"

How to run
Run from the repo root:
Bulk create users
.\scripts\bulkusers_create.ps1

Expected behavior:
- If a user already exists (same SamAccountName), it is skipped
- Otherwise, the user is created
- A summary prints at the end

Bulk delete users
.\scripts\bulkusers_delete.ps1

Expected behavior:
- If user does not exist, it is skipped
- Otherwise, the user is deleted
- A summary prints at the end
