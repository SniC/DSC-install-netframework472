Configuration NetFrameworkInstall {
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node localhost {
        Script NetFrameworkInstall {
            GetScript = {
            }

            SetScript = {
                Write-Host "Start Set"
                $url = "https://download.microsoft.com/download/6/E/4/6E48E8AB-DC00-419E-9704-06DD46E5F81D/NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
                $output = "C:\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"

                # Download file
                Invoke-WebRequest -Uri $url -OutFile $output

                # execute file
                $proc = Start-Process -FilePath "C:\NDP472-KB4054530-x86-x64-AllOS-ENU.exe" -ArgumentList "/quiet /norestart /log C:\NDP472-KB4054530-x86-x64-AllOS-ENU_install.log" -PassThru -Wait
                Switch($proc.ExitCode)
                {
                  0 {
                    # Success
                  }
                  1603 {
                    Throw "Failed installation"
                  }
                  1641 {
                    # Restart required
                    $global:DSCMachineStatus = 1                
                  }
                  3010 {
                    # Restart required
                    $global:DSCMachineStatus = 1                
                  }
                  5100 {
                    Throw "Computer does not meet system requirements."
                  }
                  default {
                    Throw "Unknown exit code $($proc.ExitCode)"
                  }
                }
            }

            TestScript = {
                Get-ChildItem 'HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\' |
                    Get-ItemPropertyValue -Name Release |
                        ForEach-Object {$_ -ge 461815}
            }
        }
    }
}

# Uncomment to test on local machine
#NetFrameworkInstall -OutputPath C:\DSCDeployment
#Start-DscConfiguration -Path C:\DSCDeployment\ -force -Wait -Verbose
