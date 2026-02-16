# PowerShell Lab: Bulk AD User Creation (CSV)

This lab automates **bulk user creation in Active Directory** using PowerShell and a CSV input file.  
It is designed for BCIT-style lab practice and portfolio demonstration.

## What this demonstrates
- PowerShell scripting for **Active Directory automation**
- Reading structured input with `Import-Csv`
- Creating users with `New-ADUser`
- Safe handling of passwords (avoid storing real passwords in GitHub)
- Basic error handling and reporting (created / skipped / failed)

## Repository structure
powershell-lab/
scripts/
bulkusers.ps1
data/
bulkusers.template.csv
.gitignore
README.md


## Prerequisites
- Windows machine joined to a domain (lab environment)
- **RSAT: Active Directory module** installed
  - The script uses `Import-Module ActiveDirectory`
- Permissions to create users in the target OU

## Safety note (important)
This repo is intended to be **public-safe**:
- Do **not** upload real CSV files containing passwords or real user data
- Commit only `bulkusers.template.csv` (fake/sample data)
- Keep your real `bulkusers.csv` local and excluded by `.gitignore`

## CSV format
A template file is provided at:
- `data/bulkusers.template.csv`

Required fields:
- `username`
- `ou` (Distinguished Name path, e.g., `CN=Users,DC=example,DC=local`)

Optional fields supported:
- `password` (use `CHANGEME` in the template)
- `firstname`, `lastname`, `email`, `streetaddress`, `city`, `state`, `country`
- `telephone`, `jobtitle`, `company`, `department`

Example row:
```csv
username,password,firstname,lastname,ou,email,streetaddress,city,state,country,telephone,jobtitle,company,department
jsmith,CHANGEME,John,Smith,"OU=Users,DC=rnakao,DC=lab",jsmith@rnakao.lab,123 Example St,Vancouver,BC,CA,6045550100,Analyst,ExampleCorp,IT
