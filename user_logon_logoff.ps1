$UserName = "User_Name"  # Replace with the desired username
$LogName = "Security"
$Days = 7  # Number of days to retrieve logs

$StartDate = (Get-Date).AddDays(-$Days)

# Retrieve user login events (Event ID 4624, Logon Type 10 - RDP)
$logons = Get-WinEvent -LogName $LogName -FilterHashtable @{LogName=$LogName; Id=4624; StartTime=$StartDate} |
    Where-Object { $_.Message -match "Account Name:\s+$UserName" -and $_.Message -match "Logon Type:\s+10" } |
    Select-Object TimeCreated, Message

# Retrieve user logout events (Event IDs 4634 and 4647)
$logoffs = Get-WinEvent -LogName $LogName -FilterHashtable @{LogName=$LogName; Id=4634, 4647; StartTime=$StartDate} |
    Where-Object { $_.Message -match "Account Name:\s+$UserName" } |
    Select-Object TimeCreated, Message

Write-Host "Login sessions for user $UserName in the last $Days days:"
$logons | ForEach-Object { Write-Host $_.TimeCreated }

Write-Host "`nLogout sessions for user $UserName in the last $Days days:"
$logoffs | ForEach-Object { Write-Host $_.TimeCreated }

