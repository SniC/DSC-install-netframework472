Configuration NetFrameworkInstall {
    Import-DscResource -ModuleName PSDesiredStateConfiguration


    Node localhost {
        Script NetFrameworkInstall {
            GetScript = {
            }

            SetScript = {
                $url = "https://download.microsoft.com/download/6/E/4/6E48E8AB-DC00-419E-9704-06DD46E5F81D/NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
                $filepath = "C:\DSCDeployment\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
                Invoke-WebRequest -Uri $url -OutFile $filepath
                Start-Process -FilePath $filepath -ArgumentList '/q /norestart' -Wait
            }

            TestScript = {
                Get-ChildItem 'HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\' |
                    Get-ItemPropertyValue -Name Release |
                        ForEach-Object {$_ -ge 461814}
            }
        }
    }
}

NetFrameworkInstall -OutputPath C:\DSCDeployment
Start-DscConfiguration -Wait -Path C:\DSCDeployment\ -Force