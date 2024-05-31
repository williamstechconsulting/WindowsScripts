Get-ADUser -Filter {Enabled -eq $false} | % {
    $User = $_
    Get-ADPrincipalGroupMembership $User | % {
        Try {
            Remove-ADPrincipalGroupMembership -Identity $User -MemberOf $_ -Confirm:$false
        } Catch {
            $Error[0]
        }
    }
}