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



#---------------------- Delete printers ----------------------------------#



#Get Current Date
$Date= Get-Date -UFormat "%m/%d/%Y"
$current_date = Get-Date

#Create List of Offline Printers
$OfflinePrinters = get-printer -ComputerName $PrintServer -name * | 
Where-Object { $_.PrinterStatus -eq "Offline" } | 
Select-Object Name,PortName,PrinterStatus,Comment | Sort-Object Name


#---Test if printer has already been commented with "Ready"------#


$string = "Tracking Offline"


#--------------------------------#


$del_printers = [System.Collections.ArrayList]@()


ForEach ($OfflinePrinter in $OfflinePrinters) {
    $printer_comment = $OfflinePrinter.Comment
    $check_inuse = "This printer is still in use"

    If ($printer_comment.Contains($string) -and !($printer_comment.Contains($check_inuse))){
        $extract_string = $OfflinePrinter.Comment
        $extract_date = [DateTime]$extract_string.SubString($extract_string.IndexOf($string) + 17)
        
        if ($extract_date.AddDays(60) -lt $current_date) {
            #add printer to del_printers array
            $del_printers.Add($OfflinePrinter)
        }
    }
}


#Change date format to add at end of csv file
$Date= Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"

#Export List of deleted Printers
#I chose to append to existing csv because have multiple csv's can be a pain to search through if looking for
#details from a deleted printer
$del_printers | export-csv "C:\user\select your folder location\name_the_csv.CSV" -NoTypeInformation -Append



#Delete printers that have been offline for over 60 days and confirm
ForEach ($printer in $del_printers){
    
    Remove-Printer -Name $printer.Name -ComputerName $PrintServer -Confirm

    #It looks like port was deleted also. Will need to confirm after running script
    #Remove-PrinterPort -Name $printer.Name -ComputerName $PrintServer -Confirm

    }


