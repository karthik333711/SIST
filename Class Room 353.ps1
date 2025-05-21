$Username = "SCAS"
$Password = "sbu@sist"

# Create a list of computer names
$ComputerNames = @()
for ($i = 1; $i -le 70; $i++) {
    $ComputerNames += "SCAS-353-" + $i.ToString("D2")  # Example: SCAS-353-01, SCAS-353-02, ...
}

# Display the list of PCs to the user and ask for a selection
$Choice = Read-Host "Select PC to connect to (1 to 70):"

# Validate the input
if ($Choice -ge 1 -and $Choice -le 70) {
    # Get the selected computer name
    $ComputerName = $ComputerNames[$Choice - 1]

    # Add credentials for the selected computer
    cmdkey /add:$ComputerName /user:$Username /pass:$Password

    # Start RDP session to the selected computer
    Start-Process "mstsc.exe" -ArgumentList "/v:$ComputerName"
} else {
    Write-Host "Invalid choice! Class Room 353 1 and 70."
}
