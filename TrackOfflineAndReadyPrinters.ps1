#Configuration Block
    #PrintServer to Connect to
    $PrintServer = "PrintServerName"

    #Set Location for Logging
    Set-Location "C:\users\select your folder location"

    #Get Current Date
    $Date= Get-Date -UFormat "%m/%d/%Y"


#Create List of Offline Printers
$OfflinePrinters = get-printer -ComputerName $PrintServer -name * | 
Where-Object { $_.PrinterStatus -eq "Offline" } | 
Select-Object Name,PortName,PrinterStatus,Comment | Sort-Object Name



#--------------------------------#




#---Test if printer has already been commented with "Tracking Offline"------#


#Moving the below variable to the for loop because "$OfflinePrinter" doesn't exist yet
#$printer_comment = $OfflinePrinter.Comment

$string = "Tracking", "Offline"


<#
($OfflinePrinter.Comment -isnot "" -or $OfflinePrinter.Comment -isnot $null)

if ($string.Contains("Track")) { 
    echo ""
    echo ""
    Write-host "String contains variable"
}

else { 
    echo ""
    echo ""
    Write-Host "String does not contain variable"
    }
#>


#--------------------------------#


ForEach ($OfflinePrinter in $OfflinePrinters) {

    $printer_comment = $OfflinePrinter.Comment

    If ($printer_comment -eq "" -or $printer_comment -eq $null){

        set-printer -name $OfflinePrinter.Name -ComputerName $PrintServer -Comment "Tracking Offline $Date"}

    #To fix error, I may need to convert IF POSSIBLE
    Elseif (!($printer_comment.Contains($string))){

        $old_comment = $printer_comment

        $new_comment = "Tracking Offline $Date"

        $appended = $old_comment + " " + $new_comment

        set-printer -name $OfflinePrinter.Name -ComputerName $PrintServer -Comment "$appended"}

}


$Date= Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"
#Export List of Offline Printers
$OfflinePrinters | export-csv "C:\Users\C:\users\select your folder location\name_the_csv.CSV" -NoTypeInformation




#---------------------- Part Two - "Ready" Printers ----------------------------------#


#Get Current Date
$Date= Get-Date -UFormat "%m/%d/%Y"

#Create List of Offline Printers
$OnlinePrinters = get-printer -ComputerName $PrintServer -name * | 
Where-Object { !($_.PrinterStatus -eq "Offline") } | 
Select-Object Name,PortName,PrinterStatus,Comment | Sort-Object Name


#---Test if printer has already been commented with "Ready"------#


$string = "Tracking", "Offline"


#--------------------------------#




ForEach ($OnlinePrinter in $OnlinePrinters) {

    $printer_comment = $OnlinePrinter.Comment
    $check_duplicate_comment = "This printer is still in use"

    If ($printer_comment.Contains($string) -and !($printer_comment.Contains($check_duplicate_comment))){

        $old_comment = $printer_comment
        $new_comment = ". This printer is still in use $Date"
        $appended = $old_comment + " " + $new_comment

        set-printer -name $OnlinePrinter.Name -ComputerName $PrintServer -Comment "$appended"}

}



$Date= Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"
#Export List of Offline Printers
$OnlinePrinters | export-csv "C:\users\select your folder location\name_the_csv.CSV" -NoTypeInformation

