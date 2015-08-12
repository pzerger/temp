
$pctComplete=0
$LogFilePath = (${env:Temp} + "\CiresonInstall" + (Get-Date -format "yyyy-MM-dd-hh-mm-ss") + ".log")

function writeToLog([string] $message)
{
    $message + "`n"
    Add-Content $LogFilePath ((Get-Date -format "yyyy-MM-dd-hh-mm-ss") + ": " + $message + "`n")
}

function writeProgress([int] $progress)
{
    ("%progress%=" + $progress+ "`n")
}


function writeWarning([string] $warning)
{
	writeToLog warning;
    ("%warning%=" + $warning + "`n")
}

function installRequiredWindowsFeatures(){

    writeToLog "Enabling required windows features."
    #Install prereq features.
    $features = @("Web-Server", "Web-Mgmt-Tools", "web-windows-auth", "Web-basic-auth", "Application-Server", "Web-Asp-Net45", "NET-Framework-Features")

    foreach($feature in $features)
    {
        try
        {
			$pctComplete = $pctComplete + 10;
			writeProgress $pctComplete;
            $srv=Get-WindowsFeature $feature
            if(! $srv.Installed){
                writeToLog ("installing feature: " + $feature)
                install-WindowsFeature $feature -Source C:\Windows\WinSxS
            }
            writeToLog ($feature + " enabled.")
        }catch [Exception]{
            $ex = $_.Exception.Message
            writeWarning ("Failed to install windows feature: " + $ex)
        }
    }
}

function installRequiredPrereqs(){
    try{
        $msiFiles = Get-ChildItem "InstallationFiles\MSI" -Filter *.msi | sort-object Name
    
        foreach($msi in $msiFiles)
        {
			$pctComplete = $pctComplete + 5
			writeProgress $pctComplete;
            writeToLog ("Installing " + $msi.Name)
            Start-Process $msi.FullName /qn -Wait        
        }
    }catch [Exception]{
        $ex = $_.Exception.Message
        writeWarning ("Failed to install prereqs: " + $ex)
    }
}


#Enable required windows features.
installRequiredWindowsFeatures
#install prereq i packages.
installRequiredPrereqs
$pctComplete = 100

writeWarning("Please restart your server to complete the installation.")
# SIG # Begin signature block
# MIITkQYJKoZIhvcNAQcCoIITgjCCE34CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU7m225w/L8Ma0shSBMmmZhSIP
# 5n2gghDHMIIFZzCCBE+gAwIBAgIRAI+8GsZzE610TS9HzwyOXnswDQYJKoZIhvcN
# AQELBQAwfTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3Rl
# cjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
# IzAhBgNVBAMTGkNPTU9ETyBSU0EgQ29kZSBTaWduaW5nIENBMB4XDTE0MTAyOTAw
# MDAwMFoXDTE2MTAyODIzNTk1OVowga8xCzAJBgNVBAYTAlVTMQ4wDAYDVQQRDAU5
# MjExMDETMBEGA1UECAwKQ2FsaWZvcm5pYTESMBAGA1UEBwwJU2FuIERpZWdvMS0w
# KwYDVQQJDCQzOTYwIFcuIFBvaW50IExvbWEgQmx2ZC4sIFN1aXRlIEgyOTAxEDAO
# BgNVBAoMB0NpcmVzb24xFDASBgNVBAsMC0RldmVsb3BtZW50MRAwDgYDVQQDDAdD
# aXJlc29uMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3X/6A3khV8MN
# UwSBE7apLYXmqAYVVPBWpuGn0Vm8u8sC3F2dirTZY/afDjBOl2a3b0cmCZ6bVCqD
# QcRMt8A8liKvvA3Rng6arjqd8/P5AVi5ZO3Tage+mDl/Qzk/rZwNleX0ZepXfJJT
# vG/lR/TgJ7PvHPW3ziHhW3JFfKJ6kIx+quW1EQ/RtexEbgfgt9GicDLfnswXoeHc
# S0lMaZYpClFGiSLCHNFxTjPYXnanm2oARuAgBJe2hjz+0WtVN8Pn54l5q2NnKD4H
# 9kXCWjvS8BI15SC24gc3F6Cda58QGGQ2Rumio+KfGnV4GTRdeT6M4Cxc86uVCZGf
# alevIR43AwIDAQABo4IBrTCCAakwHwYDVR0jBBgwFoAUKZFg/4pN+uv5pmq4z/nm
# S71JzhIwHQYDVR0OBBYEFH3iU9KvxsgogR6n4yn9EMmpVYCdMA4GA1UdDwEB/wQE
# AwIHgDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMBEGCWCGSAGG
# +EIBAQQEAwIEEDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDAjArMCkGCCsGAQUF
# BwIBFh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBDBgNVHR8EPDA6MDig
# NqA0hjJodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDb2RlU2lnbmlu
# Z0NBLmNybDB0BggrBgEFBQcBAQRoMGYwPgYIKwYBBQUHMAKGMmh0dHA6Ly9jcnQu
# Y29tb2RvY2EuY29tL0NPTU9ET1JTQUNvZGVTaWduaW5nQ0EuY3J0MCQGCCsGAQUF
# BzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETc3VwcG9y
# dEBjaXJlc29uLmNvbTANBgkqhkiG9w0BAQsFAAOCAQEAGNF/tD47sVNjTHOtAjvN
# 6SdBiDL92++zumrez+n344SVTxuHHinIU3/5vaHa7uNS5WLAA1YrJfoL6pnpDtnC
# fXmkS2TaOSSNo8BvxNxJr73+dKEJllsmNYdeEqIBqB7HjIVM9fLSwnh5HIOs9/Dc
# Fzqp+nnG1MIp2O7yUcwPPei7mGGrZGMWEfgiQRET1ZO/3quiKyLKiooVkOQmahko
# nW/4VvRUBWf5pnL2W2M13yDZuK/+qW4zLTFBgjBvJGlv2DO1GfkBpDrt0FRLC7oC
# QhhQFELxe2qK1UGwJiMjh/ZnC+dV5wuWaTFCdOarUzkqxeRBeeF06UA/vFY21tAN
# DDCCBXQwggRcoAMCAQICECdm7lbrSfOOq9dwovyE3iIwDQYJKoZIhvcNAQEMBQAw
# bzELMAkGA1UEBhMCU0UxFDASBgNVBAoTC0FkZFRydXN0IEFCMSYwJAYDVQQLEx1B
# ZGRUcnVzdCBFeHRlcm5hbCBUVFAgTmV0d29yazEiMCAGA1UEAxMZQWRkVHJ1c3Qg
# RXh0ZXJuYWwgQ0EgUm9vdDAeFw0wMDA1MzAxMDQ4MzhaFw0yMDA1MzAxMDQ4Mzha
# MIGFMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAw
# DgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDErMCkG
# A1UEAxMiQ09NT0RPIFJTQSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTCCAiIwDQYJ
# KoZIhvcNAQEBBQADggIPADCCAgoCggIBAJHoVJLSClaxrA0k3cXPRGd0mSs3o30j
# cABxvFPfxPoqEo9LfxBWvZ9wcrdhf8lLDxenPeOwBGHu/xGXx/SGPgr6Plz5k+Y0
# etkUa+ecs4Wggnp2r3GQ1+z9DfqcbPrfsIL0FH75vsSmL09/mX+1/GdDcr0MANaJ
# 62ss0+2PmBwUq37l42782KjkkiTaQ2tiuFX96sG8bLaL8w6NmuSbbGmZ+HhIMEXV
# reENPEVg/DKWUSe8Z8PKLrZr6kbHxyCgsR9l3kgIuqROqfKDRjeE6+jMgUhDZ05y
# KptcvUwbKIpcInu0q5jZ7uBRg8MJRk5tPpn6lRfafDNXQTyNUe0LtlyvLGMa31fI
# P7zpXcSbr0WZ4qNaJLS6qVY9z2+q/0lYvvCo//S4rek3+7q49As6+ehDQh6J2ITL
# E/HZu+GJYLiMKFasFB2cCudx688O3T2plqFIvTz3r7UNIkzAEYHsVjv206LiW7ey
# BCJSlYCTaeiOTGXxkQMtcHQC6otnFSlpUgK7199QalVGv6CjKGF/cNDDoqosIapH
# ziicBkV2v4IYJ7TVrrTLUOZr9EyGcTDppt8WhuDY/0Dd+9BCiH+jMzouXB5BEYFj
# zhhxayvspoq3MVw6akfgw3lZ1iAar/JqmKpyvFdK0kuduxD8sExB5e0dPV4onZzM
# v7NR2qdH5YRTAgMBAAGjgfQwgfEwHwYDVR0jBBgwFoAUrb2YejS0Jvf6xCZU7wO9
# 4CTLVBowHQYDVR0OBBYEFLuvfgI9+qbxPISOre44mOzZMjLUMA4GA1UdDwEB/wQE
# AwIBhjAPBgNVHRMBAf8EBTADAQH/MBEGA1UdIAQKMAgwBgYEVR0gADBEBgNVHR8E
# PTA7MDmgN6A1hjNodHRwOi8vY3JsLnVzZXJ0cnVzdC5jb20vQWRkVHJ1c3RFeHRl
# cm5hbENBUm9vdC5jcmwwNQYIKwYBBQUHAQEEKTAnMCUGCCsGAQUFBzABhhlodHRw
# Oi8vb2NzcC51c2VydHJ1c3QuY29tMA0GCSqGSIb3DQEBDAUAA4IBAQBkv4PxX5qF
# 0M24oSlXDeha99HpPvJ2BG7xUnC7Hjz/TQ10asyBgiXTw6AqXUz1uouhbcRUCXXH
# 4ycOXYR5N0ATd/W0rBzQO6sXEtbvNBh+K+l506tXRQyvKPrQ2+VQlYi734VXaX2S
# 2FLKc4G/HPPmuG5mEQWzHpQtf5GVklnxTM6jkXFMfEcMOwsZ9qGxbIY+XKrELoLL
# +QeWukhNkPKUyKlzousGeyOd3qLzTVWfemFFmBhox15AayP1eXrvjLVri7dvRvR7
# 8T1LBNiTgFla4EEkHbKPFWBYR9vvbkb9FfXZX5qz29i45ECzzZc5roW7HY683Ieb
# 0abv8TtvEDhvMIIF4DCCA8igAwIBAgIQLnyHzA6TSlL+lP0ct800rzANBgkqhkiG
# 9w0BAQwFADCBhTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hl
# c3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0
# ZWQxKzApBgNVBAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkw
# HhcNMTMwNTA5MDAwMDAwWhcNMjgwNTA4MjM1OTU5WjB9MQswCQYDVQQGEwJHQjEb
# MBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRow
# GAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDEjMCEGA1UEAxMaQ09NT0RPIFJTQSBD
# b2RlIFNpZ25pbmcgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCm
# mJBjd5E0f4rR3elnMRHrzB79MR2zuWJXP5O8W+OfHiQyESdrvFGRp8+eniWzX4Go
# GA8dHiAwDvthe4YJs+P9omidHCydv3Lj5HWg5TUjjsmK7hoMZMfYQqF7tVIDSzqw
# jiNLS2PgIpQ3e9V5kAoUGFEs5v7BEvAcP2FhCoyi3PbDMKrNKBh1SMF5WgjNu4xV
# jPfUdpA6M0ZQc5hc9IVKaw+A3V7Wvf2pL8Al9fl4141fEMJEVTyQPDFGy3CuB6kK
# 46/BAW+QGiPiXzjbxghdR7ODQfAuADcUuRKqeZJSzYcPe9hiKaR+ML0btYxytEjy
# 4+gh+V5MYnmLAgaff9ULAgMBAAGjggFRMIIBTTAfBgNVHSMEGDAWgBS7r34CPfqm
# 8TyEjq3uOJjs2TIy1DAdBgNVHQ4EFgQUKZFg/4pN+uv5pmq4z/nmS71JzhIwDgYD
# VR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwEQYDVR0gBAowCDAGBgRVHSAAMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6
# Ly9jcmwuY29tb2RvY2EuY29tL0NPTU9ET1JTQUNlcnRpZmljYXRpb25BdXRob3Jp
# dHkuY3JsMHEGCCsGAQUFBwEBBGUwYzA7BggrBgEFBQcwAoYvaHR0cDovL2NydC5j
# b21vZG9jYS5jb20vQ09NT0RPUlNBQWRkVHJ1c3RDQS5jcnQwJAYIKwYBBQUHMAGG
# GGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTANBgkqhkiG9w0BAQwFAAOCAgEAAj8C
# OcPu+Mo7id4MbU2x8U6ST6/COCwEzMVjEasJY6+rotcCP8xvGcM91hoIlP8l2KmI
# pysQGuCbsQciGlEcOtTh6Qm/5iR0rx57FjFuI+9UUS1SAuJ1CAVM8bdR4VEAxof2
# bO4QRHZXavHfWGshqknUfDdOvf+2dVRAGDZXZxHNTwLk/vPa/HUX2+y392UJI0kf
# Q1eD6n4gd2HITfK7ZU2o94VFB696aSdlkClAi997OlE5jKgfcHmtbUIgos8MbAOM
# TM1zB5TnWo46BLqioXwfy2M6FafUFRunUkcyqfS/ZEfRqh9TTjIwc8Jvt3iCnVz/
# RrtrIh2IC/gbqjSm/Iz13X9ljIwxVzHQNuxHoc/Li6jvHBhYxQZ3ykubUa9MCEp6
# j+KjUuKOjswm5LLY5TjCqO3GgZw1a6lYYUoKl7RLQrZVnb6Z53BtWfhtKgx/GWBf
# DJqIbDCsUgmQFhv/K53b0CDKieoofjKOGd97SDMe12X4rsn4gxSTdn1k0I7OvjV9
# /3IxTZ+evR5sL6iPDAZQ+4wns3bJ9ObXwzTijIchhmH+v1V04SF3AwpobLvkyanm
# z1kl63zsRQ55ZmjoIs2475iFTZYRPAmK0H+8KCgT+2rKVI2SXM3CZZgGns5IW9S1
# N5NGQXwH3c/6Q++6Z2H/fUnguzB9XIDj5hY5S6cxggI0MIICMAIBATCBkjB9MQsw
# CQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQH
# EwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDEjMCEGA1UEAxMa
# Q09NT0RPIFJTQSBDb2RlIFNpZ25pbmcgQ0ECEQCPvBrGcxOtdE0vR88Mjl57MAkG
# BSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJ
# AzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMG
# CSqGSIb3DQEJBDEWBBT/DY1Fn47NDhtzQNqyVJ8NCUs5LjANBgkqhkiG9w0BAQEF
# AASCAQAWLmARe9/2YQNsk2PCXAGjil4332j7g0PZsa6pTI9fPPyncOra56leAiaB
# kPT7WiEMtCh4qrvyM8AP4AkseDLcM0ORQAtgYBu0BUCAaZLtujb7ZR2M654rrQ7D
# yvZDL+75DKfPeyPXs3m2sSFONKJ8iPmXZ+i6f3munVOiQTJxtQWeWS+gT+Ac16Cc
# 3o4peT5Q8n663iBwp/8smAHlG1uNIxHr92MBEyff/3ChqMVBSKJAdqLAtCnY18JS
# ckOe66sGAa2TWMurB8IYxRN8KPOdVC3UVzcN+VRh+/mtLqh3xJZidWzzmyOdcajo
# ijOUQSyfOicRwjqiSBdloue0G71e
# SIG # End signature block
