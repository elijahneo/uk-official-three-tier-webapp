$Computername = $env:COMPUTERNAME
$ToEmail = "myemailaddress@mydomain.com"
$FromEmail = "WSUS.on.$Computername@mydomain.com"
$smtpServer = "mysmtpServer"
# Polling frequency in seconds
$Seconds = "320"
 
cls
Write-host 'Monitoring WSUS Update File Downloads...'
write-host 'Will send email when completed.'
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer();
$updateScope = new-object Microsoft.UpdateServices.Administration.UpdateScope;
$updateScope.updateApprovalActions = [Microsoft.UpdateServices.Administration.UpdateApprovalActions]::Install
while (($wsus.GetUpdates($updateScope) | Where {$_.State -eq "NotReady"}).Count -ne 0) {
Start-Sleep -Seconds $Seconds
}
#send-mailmessage -To $ToEmail -From $FromEmail -Subject "WSUS Update File Download Completed on $ComputerName" -body "Download of Update Files on $Computername has completed!" -smtpServer $smtpServer
write-host "completed"
