$UserName = "User"  
$LogName = "Security"
$Days = 90  # Number of days to retrieve logs
$StartDate = (Get-Date).AddDays(-$Days)

# Get login events (Event ID 4624, Logon Type 10 - RDP)
$logons = Get-WinEvent -LogName $LogName -ErrorAction SilentlyContinue | 
Where-Object { $_.Id -eq 4624 -and $_.Message -match "Account Name:\s+$UserName" -and $_.Message -match "Logon Type:\s+10" } |
Select-Object TimeCreated

# Get logout events (Event IDs 4634 and 4647)
$logoffs = Get-WinEvent -LogName $LogName -ErrorAction SilentlyContinue |
Where-Object { ($_.Id -eq 4634 -or $_.Id -eq 4647) -and $_.Message -match "Account Name:\s+$UserName" } |
Select-Object TimeCreated

Write-Host "Login sessions for user $UserName in the last $Days days:"
$logons | ForEach-Object { Write-Host $_.TimeCreated }

Write-Host "`nLogout sessions for user $UserName in the last $Days days:"
$logoffs | ForEach-Object { Write-Host $_.TimeCreated }
