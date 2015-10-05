

# Create SQL login

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


# Install SCSM 2012 R2
# Requires domain user with local admin rights. 

Start-Executable -FilePath $SmExeFile -ArgumentList $SmArgs

# Install SCSM Management Group. Must be run as a domain user with local admin rights.
$SmExeFile = 'C:\SC2012 R2 SCSM\amd64\setup.exe'
$p = Start-Process $SmExeFile -ArgumentList '/Install:Server /AcceptEula:YES /RegisteredOwner:"Contoso Admin" /RegisteredOrganization:"Contoso Corp" /ProductKey:BXH69-M62YX-QQD6R-3GPWX-8WMFY /CreateNewDatabase /ManagementGroupName:mg_cireson /AdminRoleGroup:"contoso.corp\domain admins" /ServiceRunUnderAccount:contoso.corp\adadmin\P@ssw0rd1! /WorkflowAccount:contoso.corp\adadmin\P@ssw0rd1! /CustomerExperienceImprovementProgram:NO /EnableErrorReporting:NO /Silent' -wait -NoNewWindow -PassThru

    # returns "TRUE" when complete
    $p.HasExited

    # Exit code is 0 if successful
    # Error codes - https://technet.microsoft.com/en-us/library/hh524280.aspx
    $p.ExitCode


