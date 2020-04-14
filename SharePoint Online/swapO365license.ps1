Import-Module MSOnline
$cred = Get-Credential 
Connect-MsolService -Credential $cred 
 
$oldLicense = "HCScompany:ENTERPRISEPACK" #E3
$newLicense = "HCScompany:ENTERPRISEPREMIUM_NOPSTNCONF" #E5
 
$users = Get-MsolUser -MaxResults 5000 | Where-Object { $_.isLicensed -eq "TRUE" } 
 
foreach ($user in $users) { 
    $upn = $user.UserPrincipalName 
    foreach ($license in $user.Licenses) { 
        if ($license.AccountSkuId -eq $oldLicense) { 
            $disabledPlans = @() 
            foreach ($licenseStatus in $license.ServiceStatus) { 
                $plan = $licenseStatus.ServicePlan.ServiceName 
                $status = $licenseStatus.ProvisioningStatus 
                if ($status -eq "Disabled") { 
                    # We found a disabled service. We might need to translate it. 
                    # For example, in an E1 license, Exchange Online is called "EXCHANGE_S_STANDARD", and 
                    # in an E3 license it's called "EXCHANGE_ENTERPRISE". 
 
                    if ($plan -eq "EXCHANGE_S_STANDARD") { 
                        $disabledPlans += "EXCHANGE_S_ENTERPRISE" 
                    }
                    elseif ($plan -eq "SHAREPOINTSTANDARD") { 
                        $disabledPlans += "SHAREPOINTWAC" 
                        $disabledPlans += "SHAREPOINTENTERPRISE" 
                    }
                    else { 
                        # Example: MCOSTANDARD 
                        $disabledPlans += $plan 
                    }                     
                } 
            } 
            # Always disabled Office 365 Pro Plus. 
            # $disabledPlans += "OFFICESUBSCRIPTION" 
            # $disabledPlans += "RMS_S_ENTERPRISE"  
            # $disabledPlans = $disabledPlans | select -Unique 
            #if ($disabledPlans.Length -eq 0) { 
            #    Write-Host("User $upn will go from $oldLicense to $newLicense and will have no options disabled.") 
            #    Set-MsolUserLicense -UserPrincipalName $upn -AddLicenses $newLicense -RemoveLicenses $oldLicense  
            #}
            #else { 
            $options = New-MsolLicenseOptions -AccountSkuId $newLicense -DisabledPlans $disabledPlans 
            Write-Host("User $upn will go from $oldLicense to $newLicense and will have these options disabled: $disabledPlans") 
            #Set-MsolUserLicense -UserPrincipalName $upn -AddLicenses $newLicense -LicenseOptions $options -RemoveLicenses $oldLicense  
            #} 
        } 
    } 
}