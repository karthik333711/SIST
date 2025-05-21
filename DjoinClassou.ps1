# Predefined ClassRoom Name
$ClassRoom = "SCAS-"

do {
    do {
        # Prompt for PC number
        Write-Host -NoNewline "Enter the PC Number: $ClassRoom"
        $PcNumber = Read-Host
        $PcNumber = $PcNumber.Trim()
    } while ([string]::IsNullOrWhiteSpace($PcNumber))

    # Construct the full PC name
    $newComputerName = "$ClassRoom$PcNumber"

    # Show the new name
    Write-Host "`nNEW PC NAME IS : $newComputerName" -ForegroundColor Green
    Write-Host "If the name is OK, press ENTER to continue." -ForegroundColor Cyan
    Write-Host "If NOT OK, press ESC to Re-Enter PC Number." -ForegroundColor Yellow

    # Get key press
    $key = [System.Console]::ReadKey($true)
} while ($key.Key -eq 'Escape')

Write-Host "`nNow $newComputerName system will join domain. Please wait..." -ForegroundColor Cyan






if ($confirmation -eq "") {
    Write-Host "Proceeding with the new computer name: $newComputerName"
} else {
    Write-Host "Aborted. No changes made."
}



# Rename the computer
Rename-Computer -NewName $newComputerName -Force

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString 'admin@123' -AsPlainText -Force

# Create the credential object
$cred = New-Object System.Management.Automation.PSCredential ('sist\itadmin', $securePassword)

# Define the OU path where the computer will be added
$ouPath = "OU=CLASSROOM 319,DC=sist,DC=com"

# Define parameters for Add-Computer
$addComputerSplat = @{
DomainName = 'sist.com'
Credential = $cred
OUPath = $ouPath
Options = 'JoinWithNewName', 'AccountCreate'
}

# Join the computer to the domain
Add-Computer @addComputerSplat



schtasks /delete /tn "Djoin" /f

Remove-Item -Path "C:\Windows\SCAS\Djoin" -Recurse -Force

Write-Host "Press Enter to Restart the computer."
Read-Host
Restart-Computer

