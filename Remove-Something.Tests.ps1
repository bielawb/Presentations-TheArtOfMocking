Describe Break {
    Context Allow {
        It 'Should remove a lot if items (in whatIf mode)' {
            { Remove-Something } | Should -Not -Throw
        }
    }

    Context Prevent {
        It 'Should not touch disk' {
            Mock -CommandName Remove-Item -MockWith {
                Write-Warning "Not going to to touch $Path"
            }
            { Remove-Something } | Should -Not -Throw
        }
    }
}