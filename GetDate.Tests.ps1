Describe Dates {
    Context Random {
        It 'is Xmas every day...?' {
            $result = Get-Date
            $result.Day | Should -Be 25
            $result.Month | Should -Be 12
        }
    }

    Context Predictable {
        It 'IS Xmas every day!' {
            Mock -CommandName Get-Date -MockWith {
                [DateTime]'2022-12-25'
            }
            $result = Get-Date
            $result.Day | Should -Be 25
            $result.Month | Should -Be 12            
        }
    }
}