Describe NewObjectMock {
    BeforeAll {
        Mock -CommandName New-Object -ParameterFilter {
            $TypeName -eq 'ADSI'
        } -MockWith {
            @{
                distinguishedName = 'DC=psconf,DC=eu'
                Path = ''
            }
        }

        Mock -CommandName New-Object -ParameterFilter {
            $TypeName -eq 'ADSISearcher'
        } -MockWith {
            $searcher = [PSCustomObject]@{
                PropertiesToLoad = $ArgumentList[2]
                Filter = $ArgumentList[1]
            }
            
            $searcher | Add-Member -MemberType ScriptMethod -Name FindAll -Value {
                , ([PSCustomObject]@{
                    Path = 'LDAP://CN=Bartek B,OU=ISEUsers,DC=psconf,DC=eu'
                    Properties = @{
                        name = , 'Bartek B'
                        title = , 'Guy That Does PowerShell'
                        adspath = , 'LDAP://CN=Bartek B,OU=ISEUsers,DC=psconf,DC=eu'
                    }
                }) 
            }
            $searcher
        }

        $continue = @{
            ErrorAction = 'Continue'
        }
    }

    It FindsMe {
        $results = Find-ADObject -Filter name=bar* -Properties name, title
        $results.title | Should @continue -BeExactly 'Guy That Does PowerShell'
        $results.name | Should @continue -BeExactly 'Bartek B'
    }
}