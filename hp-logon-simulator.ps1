# Description: This script increases logonCount, lastLogon, lastLogonDate, lastLogonTimestamp, lastBadpasswordAttempt, badPwdCount attribute for the honeyPot accounts so they look more real.

$logFile = "C:\Script\HP-Logon-Simulator\logfile.txt"
$domainName = "contoso.com"
$domainController = "dc01"

# Username + Password
$hpcredentials = @("hp_user1","12346789"), # e.g. nerver expires pw
                 @("hp_user2","987654321"), # e.g. change Password 1 a year!!!
                 @("hp_user2","SIMULATE_WRONG_PASSWORD") # e.g. simulate failed logon attempt

# prepare random user credentials                
$randomNum = Get-Random -Maximum $hpcredentials.Count
$user = $hpcredentials[$randomNum][0]
$password = $hpcredentials[$randomNum][1]
$userName = $domainName+"\"+$user
$credentials = New-Object System.Management.Automation.PSCredential ($userName, (ConvertTo-SecureString $password -AsPlainText -Force))

#sleep between 0 - 3 min for more randomized lastLogon timestamp
sleep $(Get-Random -Maximum 180)


try{
    Invoke-Command -ComputerName $domainController -Credential $credentials -Authentication Kerberos -ScriptBlock { Get-Date }
    $date = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    echo "$($date)   [+] SUCCESSFULL login as $($user)" | Out-File $logfile -Append
}

Catch {
    $date = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    echo "$($date)   [-] ERROR login as $($user) $($_.Exception.Message)" | Out-File $logfile -Append
}