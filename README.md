# PowerShell Lab: Bulk Active Directory User Management (CSV)
## Overview
This repo archives a BCIT in-class PowerShell lab for:
- Bulk **AD user creation** from CSV
- Bulk **AD user deletion** from CSV

For public sharing, the sample uses placeholders like `example.local` and a template CSV.

## Repository Structure
- `scripts/bulkusers_create.ps1`
- `scripts/bulkusers_delete.ps1`
- `data/bulkusers.template.csv`
- `.gitignore`
- `README.md`

## Requirements
- Windows + **RSAT ActiveDirectory module**
- Permissions to create/delete users in the target OU/container

## CSV Template
File: `data/bulkusers.template.csv`  
Header:
```csv
firstname,lastname,username,password,email,streetaddress,city,state,country,department,telephone,jobtitle,company,ou
```
Minimum fields:
-`username`
-`password (create)`
-`ou` (DN path like CN=Users,DC=example,DC=local)

Template values:
-password uses CHANGEME
-domain placeholders use example.local / DC=example,DC=local

To run in your lab domain (e.g., ryohei.lab), update:
-create script UPN suffix (example.local → your domain)
-CSV ou DN (DC=example,DC=local → your domain DN)

CSV path in scripts
-Both scripts read the template CSV from:
```
$CSVPath = Join-Path $PSScriptRoot "..\data\bulkusers.template.csv"
```

## How to Run
From repo root:
Create users:
```
.\scripts\bulkusers_create.ps1
```

Delete users (destructive):
```
.\scripts\bulkusers_delete.ps1
```

Safer delete test:
```
Remove-ADUser -Identity $Username -WhatIf
```

## Scripts
### Bulk Create Users
### Bulk Delete Users (only if your delete script is included)
## Safety Notes
## What I Practiced / Learned
-Import-Csv, New-ADUser, Remove-ADUser
-Existence checks before create/delete
-Working with OU/CN Distinguished Names
-Counters + summary output

## Disclaimer
Educational/lab use only. Do not upload real passwords or production data to a public repository.
```
::contentReference[oaicite:0]{index=0}
```
