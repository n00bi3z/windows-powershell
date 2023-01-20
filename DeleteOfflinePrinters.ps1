#Configuration Block
    #PrintServer to Connect to
    $PrintServer = "YOURPRINTSERVER"

    #Set Location for Logging
    Set-Location "Log file location"

#Get Past Date
$Date= (Get-Date).AddMonths(-1)

#Create List of Offline Printers
$OfflinePrinters = get-printer -ComputerName $PrintServer -name ADM*,BHS*,GA*,GICA*,PBX*,RAX* | Where-Object { $_.Comment -lt $Date -and $_.Comment -ne $null} | Sort-Object Name

#Display Offline Printers
get-printer -ComputerName $PrintServer -name ADM*,BHS*,GA*,GICA*,PBX*,RAX* | Where-Object { $_.Comment -lt $Date -and $_.Comment -ne ""} | Select-Object Name,PrinterStatus,PortName,Comment | Sort-Object Name | Format-Table -AutoSize

#Delete Offline Printers
ForEach-Object {
Remove-Printer -Name $OfflinePrinters.Name -ComputerName $PrintServer  -Confirm
Remove-PrinterPort -Name $OfflinePrinters.PortName -ComputerName $PrintServer -Confirm
 }

 #Document Deletion
 $Date= Get-Date
 $TimeStamp = "These printers were deleted on $Date."
 $TimeStamp | Out-file DeletedPrinters.CSV -Append 
 $OfflinePrinters| Out-file DeletedPrinters.CSV -Append
