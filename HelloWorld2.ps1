#################################
#
#
# Download and Install 
#
#################################

Install-WindowsFeature -Name NET-Framework-Features

# Analysis Mgmt Objects 
$source = "http://go.microsoft.com/fwlink/?LinkID=239666&clcid=0x409"
$destination = "c:\Windows\temp\AMO.msi"
 
Invoke-WebRequest $source -OutFile $destination

$path = 'c:\temp\AMO.msi'
        # Write-Host "Installaing $path...."
        $args = " /i $destination /qb"
        [diagnostics.process]::start("msiexec", $args).WaitForExit()
        # Write-Host "Installed $path"


# SQL Native Client
$source = "http://go.microsoft.com/fwlink/?LinkID=239648&clcid=0x409"
$destination = "c:\Windows\temp\nc.msi"
 
Invoke-WebRequest $source -OutFile $destination

$path = $destination
        # Write-Host "Installaing $path...."
        $args = " /i $destination /qb IACCEPTSQLNCLILICENSETERMS=YES"
        [diagnostics.process]::start("msiexec", $args).WaitForExit()
        # Write-Host "Installed $path"