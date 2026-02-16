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
