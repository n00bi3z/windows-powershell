Import-Module ActiveDirectory 
Add-Type -AssemblyName PresentationCore,PresentationFramework


#Can add code to confirm hostname. I previously used another method to create username using hostname
$new_account = Read-Host "What is the account name?"

$description = 'Windows User Account'
$display_name = $new_account
$ou = 'OU=OU_here' 
$pass = “password here”
$get_ad_account = Get-ADUser -Identity $new_account

#if account exists - display message
$msgBody_exist = "$new_account ALREADY EXISTS!`n`n$get_ad_account `n`nEXITING..."

#if account does not exist - display message
$msgBody_not_exist = "$new_account Does Not Exist`n`nCreating it..."


Function Create-new_account {

    if (Get-ADUser -Filter "samaccountname -eq '$new_account'"){
        
        #Display message box that account already exists
        [System.Windows.MessageBox]::Show($msgBody_exist)

        }

    else{

        #Display message box that account does not exist and creating it
        [System.Windows.MessageBox]::Show($msgBody_not_exist)

        New-ADUser -Name $new_account -GivenName $new_account -SamAccountName $new_account -UserPrincipalName "$new_account@your_domain_here.org" -Path $ou -AccountPassword (ConvertTo-SecureString $pass -AsPlainText -Force) -DisplayName $display_name -Description $description -Enabled $true
        Add-ADGroupMember -Identity "Security group here" -Members $new_account

        #Show ad account name, upn, and dn after creation
        #                 ----
        #Placed the variables here to avoid "Cannot find an object with identity" if placed with 
        #variable declarations at the top
        $get_name = Get-ADUser $new_account -Properties * | Select-Object -ExpandProperty Name
        $get_upn = Get-ADUser $new_account -Properties * | Select-Object -ExpandProperty UserPrincipalName
        $get_dn = Get-ADUser $new_account -Properties * | Select-Object -ExpandProperty DistinguishedName

        #Show Name, UPN, and Distinguished Name in message box after creation
        [System.Windows.MessageBox]::Show("Account Name: $get_name `n`nUPN: $get_upn`n`nOU: $get_dn")

        }
    }


Try{
    
    Create-new_account
    
    }

Catch{
    
    Write-Host "Please create the account manually"
    
    }
