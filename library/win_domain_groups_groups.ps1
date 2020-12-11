#!powershell

#Requires -Module Ansible.ModuleUtils.Legacy
#AnsibleRequires -CSharpUtil Ansible.AccessToken

try {
    Import-Module ActiveDirectory
 }
 catch {
     Fail-Json $result "Failed to import ActiveDirectory PowerShell module. This module should be run on a domain controller, and the ActiveDirectory module must be available."
 }

$result = @{
    changed = $false
}

$params = Parse-Args $args -supports_check_mode $true
$check_mode = Get-AnsibleParam -obj $params -name "_ansible_check_mode" -default $false

# Module control parameters
$name = Get-AnsibleParam -obj $params -name "name" -type "str" -failifempty $true
$groups = Get-AnsibleParam -obj $params -name "groups" -type "list"
$groups_action = Get-AnsibleParam -obj $params -name "groups_action" -type "str" -default "replace" -validateset "add","remove","replace"
$domain_username = Get-AnsibleParam -obj $params -name "domain_username" -type "str"
$domain_password = Get-AnsibleParam -obj $params -name "domain_password" -type "str" -failifempty ($null -ne $domain_username)
$domain_server = Get-AnsibleParam -obj $params -name "domain_server" -type "str"

$extra_args = @{}
if ($null -ne $domain_username) {
    $domain_password = ConvertTo-SecureString $domain_password -AsPlainText -Force
    $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $domain_username, $domain_password
    $extra_args.Credential = $credential
}
if ($null -ne $domain_server) {
    $extra_args.Server = $domain_server
}
try {
    $target_group = Get-ADGroup -Identity $name -Properties * @extra_args
    $target_group_dn = $target_group.DistinguishedName
} catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
    $target_group = $null
} catch {
    Fail-Json $result "failed to retrieve details for group $($name): $($_.Exception.Message)"
}

Function Get-PrincipalGroups {
    Param ($identity, $args_extra)
    try{
        $groups = Get-ADPrincipalGroupMembership -Identity $identity @args_extra -ErrorAction Stop
    } catch {
        Add-Warning -obj $result -message "Failed to enumerate groups but continuing on.: $($_.Exception.Message)"
        return @()
    }

    $result_groups = foreach ($group in $groups) {
        $group.DistinguishedName
    }
    return $result_groups
}

$group_list = $groups

$groups = @()
Foreach ($group in $group_list) {
    $groups += (Get-ADGroup -Identity $group @extra_args).DistinguishedName
}

$assigned_groups = Get-PrincipalGroups $target_group_dn $extra_args

switch ($groups_action) {
    "add" {
        Foreach ($group in $groups) {
            If (-not ($assigned_groups -Contains $group)) {
                Add-ADGroupMember -Identity $group -Members $target_group_dn -WhatIf:$check_mode @extra_args
                $result.changed = $true
            }
        }
    }
    "remove" {
        Foreach ($group in $groups) {
            If ($assigned_groups -Contains $group) {
                Remove-ADGroupMember -Identity $group -Members $target_group_dn -Confirm:$false -WhatIf:$check_mode @extra_args
                $result.changed = $true
            }
        }
    }
    "replace" {
        Foreach ($group in $assigned_groups) {
            If (-not $groups -Contains $group) {
                Remove-ADGroupMember -Identity $group -Members $target_group_dn -Confirm:$false -WhatIf:$check_mode @extra_args
                $result.changed = $true
            }
        }
        Foreach ($group in $groups) {
            If (-not ($assigned_groups -Contains $group)) {
                Add-ADGroupMember -Identity $group -Members $target_group_dn -WhatIf:$check_mode @extra_args
                $result.changed = $true
            }
        }
    }
}

Exit-Json $result
