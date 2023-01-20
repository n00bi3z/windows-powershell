


$workstation = Read-Host "What is the workstation name?"


if(get-adcomputer -filter "Name -eq '$workstation'"){
   "$workstation exists in AD"
   }
else{
    "$workstation does not exist in AD"
    Exit
    }


$obj = Get-ADComputer $workstation



Set-ADComputer -Identity $obj -Server FULLY_QUAL_SERVER_NAME_HERE -Enabled $false
echo ""
echo ""
echo "------------------ $workstation WORKSTATION HAS BEEN DISABLED!!!------------------------"
echo ""
echo ""



$local_account = "local_" + $workstation


if(Get-AdUser -filter "Name -eq '$local_account'"){
   echo "--------------Local_Account Exists... Disabling.....-------------------------------"
   echo ""
   }
else{
    echo "--------------Local_Account does not exist!!! ----------------------------------"
    echo ""
    echo "-------------- EXITING ----------------------------------"
    Exit
    }


$obj = Get-ADUser $local_account
Set-ADUser -Identity $obj -Server FULLY_QUAL_SERVER_NAME_HERE -Enabled $false 
echo " ------------------$uaccount Local_ACCOUNT HAS BEEN DISABLED!!!------------------------"
echo ""
echo ""

