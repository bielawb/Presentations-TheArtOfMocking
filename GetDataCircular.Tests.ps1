Describe Circle {
    Context WeGo {
        BeforeAll {
            Mock -CommandName Get-Date -MockWith {
                Get-Date -Date '2022-12-25'
            }
        }

        It Fails {
            $out = Get-Date
            $out.Day | Should -Be 25
        }
    }
}