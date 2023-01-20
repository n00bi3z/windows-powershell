$old_account = Read-Host "What is the old workstation hostname?"
$new_account = Read-Host "What is the new workstation hostname?"
# This is wrong....---> Get-ADComputer -Identity $old_account -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members $new_account

$CopyFromComp = Get-ADComputer $old_account -prop MemberOf
echo "old workstation groups:"
echo "" 
echo $CopyFromComp 

$CopyToComp = Get-ADComputer $new_account -prop MemberOf
echo "new workstation groups:"
echo "" 
echo $CopyToComp 

$CopyFromComp.MemberOf | Where{$CopyToComp.MemberOf -notcontains $_} |  Add-ADGroupMember -Members $CopyToComp

$update = Get-ADComputer $new_account -prop MemberOf
echo $update
