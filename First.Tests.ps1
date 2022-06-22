Describe Tests {
    Context First {
        BeforeAll {
            Mock -CommandName ping.exe
        }

        It 'Will work' {
            ping.exe | Should -BeNullOrEmpty
        }
    }
    Context Second {
        BeforeAll {
            Mock -CommandName dcdiag.exe
        }

        It 'Will fail' {
            dcdiag.exe | Should -BeNullOrEmpty
        }
    }
}