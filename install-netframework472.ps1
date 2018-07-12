Configuration NetFrameworkInstall {
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node localhost {
        Script NetFrameworkInstall {
            GetScript = {
            }

            SetScript = {
                $url = "https://download.microsoft.com/download/6/E/4/6E48E8AB-DC00-419E-9704-06DD46E5F81D/NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
                $output = "C:\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"

                # Download file
                Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing

                # execute file
                Start-Process -FilePath $output -ArgumentList '/passive /norestart' -Wait
            }

            TestScript = {
                Get-ChildItem 'HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\' |
                    Get-ItemPropertyValue -Name Release |
                        ForEach-Object {$_ -ge 461814}
            }
        }
    }
}

# Uncomment to test on local machine
# NetFrameworkInstall -OutputPath C:\DSCDeployment
# Start-DscConfiguration -Wait -Path C:\DSCDeployment\ -Force