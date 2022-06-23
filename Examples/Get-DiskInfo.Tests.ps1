Describe PipeThing {
    Context Prevent {
        It 'Should not touch disk' {
            Mock -CommandName Get-Disk -MockWith {
                [PSCustomObject]@{
                    Number = 1
                }
            }
            Mock -CommandName Get-Partition

            { Get-DiskInfo } | Should -Not -Throw
        }
    }
}