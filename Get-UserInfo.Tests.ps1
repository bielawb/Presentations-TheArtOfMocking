Describe Info {
    Context NoCommandNoCry {
        BeforeAll {
            Mock -CommandName Get-ADUser -MockWith {
                @{
                    DisplayName = 'Mr. Beans'
                    SamAccountName = 'mrbeans'
                }
            }
            Mock -CommandName Invoke-DbaQuery -MockWith {
                @{
                    ID = 1234
                }
            }

            $continue = @{
                ErrorAction = 'Continue'
            }
        }

        It 'Depends' {
            $result = Get-UserInfo -Name MrBeans
            Should @continue -Invoke -CommandName Get-ADUser -Times 1 -Exactly -ParameterFilter {
                $Identity -eq 'MrBeans'
            }
            Should @continue -Invoke -CommandName Invoke-DbaQuery -Times 1 -Exactly -ParameterFilter {
                $Query -like '*"MrBeans"*'
            }
        }
    }
}