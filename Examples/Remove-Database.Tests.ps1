Describe Missing {
    Context NoPipe {
        It 'Will die because nulls are not great' {
            Mock -CommandName Get-DbaDatabase
            Mock -CommandName Remove-DbaDatabase
            { Remove-Database } | Should -Throw
        }
    }

    Context PipeFixed {
        It 'Should work when we pretend we have DB to delete' {
            Mock -CommandName Get-DbaDatabase -MockWith {
                [PSCustomObject]@{
                    Database = 'Test'
                    SqlInstance = 'TestMock'
                }
            }
            Mock -CommandName Remove-DbaDatabase

            { Remove-Database } | Should -Not -Throw
        }
    }
}