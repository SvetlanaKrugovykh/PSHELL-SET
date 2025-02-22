Set-ExecutionPolicy RemoteSigned -Scope Process


powershell -ExecutionPolicy Bypass -File .\user_logon_logoff.ps1

Get-ExecutionPolicy -List