
<#
# Create SQL login
Import-Module SQLPS
$conn = New-Object Microsoft.SqlServer.Management.Common.ServerConnection -ArgumentList $env:ComputerName
$conn.applicationName = "PowerShell SMO"
$conn.ServerInstance = "localhost"
$conn.StatementTimeout = 0
$conn.Connect()
$smo = New-Object Microsoft.SqlServer.Management.Smo.Server -ArgumentList $conn
$SqlUser = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $smo,"contoso\adadmin" 
$SqlUser.LoginType = 'WindowsUser'
$sqlUser.PasswordPolicyEnforced = $false
$SqlUser.Create()

# Add login to sysadmin role
$SqlUser.AddToRole('sysadmin')

#>

#Create SQL Login
import-module SQLPS
$cnString = "server=localhost;database=master;user id='contoso\adadmin';password='P@ssw0rd1!';trusted_connection=true;"
$cn = new-object system.data.sqlclient.sqlconnection($cnstring)
$cnSql = New-Object Microsoft.sqlserver.management.common.serverconnection($cn)
$s = New-Object Microsoft.sqlserver.management.smo.server($cnSql)
# $s | Select Name, Version


$SqlUser = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $s,"contoso\adadmin" 
$SqlUser.LoginType = 'WindowsUser'
$sqlUser.PasswordPolicyEnforced = $false
$SqlUser.Create()

# Add login to sysadmin role
$SqlUser.AddToRole('sysadmin')

# login created successfully


# Download System Center Service Manager 2012 R2 
$source = "http://care.dlservice.microsoft.com/dl/download/evalx/sc2012r2/SC2012_R2_SCSM.exe"
$destination = "c:\Windows\temp\SC2012_R2_SCSM.exe"

Invoke-WebRequest $source -OutFile $destination

# Extract SCSM installation media 

$p = Start-Process $destination -ArgumentList "/verysilent" -wait -NoNewWindow -PassThru

    # returns "TRUE" when complete
    $p.HasExited

    # Exit code is 0 if successful
    $p.ExitCode

    # Verify the file exists (extraction successful) 

    $verifySmExe = Test-Path -Path 'C:\SC2012 R2 SCSM\amd64\setup.exe'

#<#

# Install SCSM 2012 R2
# Requires domain user with local admin rights. 

# Start-Executable -FilePath $SmExeFile -ArgumentList $SmArgs

# Set SQL Server Agent startup type to 'Automatic' and start
Set-Service SQLSERVERAGENT -startuptype "automatic"
Start-Service SQLSERVERAGENT

# Install SCSM Management Group. Must be run as a domain user with local admin rights.
$SmExeFile = 'C:\SC2012 R2 SCSM\amd64\setup.exe'

# Provide credentials to run process as a domain user
# Found credential guidance at http://blogs.technet.com/b/benshy/archive/2012/06/04/using-a-powershell-script-to-run-as-a-different-user-amp-elevate-the-process.aspx
$credential = New-Object System.Management.Automation.PsCredential("contoso\adadmin", (ConvertTo-SecureString "P@ssw0rd1!" -AsPlainText -Force))

$p = Start-Process $SmExeFile -Credential $credential -ArgumentList '/Install:Server /AcceptEula:YES /RegisteredOwner:"Contoso Admin" /RegisteredOrganization:"Contoso Corp" /ProductKey:BXH69-M62YX-QQD6R-3GPWX-8WMFY /CreateNewDatabase /ManagementGroupName:mg_cireson /AdminRoleGroup:"contoso.corp\domain admins" /ServiceRunUnderAccount:contoso.corp\adadmin\P@ssw0rd1! /WorkflowAccount:contoso.corp\adadmin\P@ssw0rd1! /CustomerExperienceImprovementProgram:NO /EnableErrorReporting:NO /Silent' -wait -NoNewWindow -PassThru

    # returns "TRUE" when complete
    $p.HasExited

    # Exit code is 0 if successful
    # Error codes - https://technet.microsoft.com/en-us/library/hh524280.aspx
    $p.ExitCode


    #>