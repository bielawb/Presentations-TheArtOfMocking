Describe CatchOrNot {
    Context WingIt {
        BeforeAll {
            Mock -CommandName Remove-DbaDatabase -ParameterFilter {
                $Database -eq 'Test' -and
                $SqlInstance -eq 'Pester'
            }

            $params = @{
                Name = 'Test'
                Instance = 'Pester'
            }
        }

        It TriesNastyThings {
            Remove-AnnoyingDatabase @prms
            Should -Invoke -CommandName Remove-DbaDatabase -Times 1 -Exactly
        }
    }

    Context SeatBeltOn {
        BeforeAll {
            Mock -CommandName Remove-DbaDatabase -MockWith {
                throw "Unexpected parameter values: Database ($Database) or SqlInstance ($SqlInstance)"
            }

            Mock -CommandName Remove-DbaDatabase -ParameterFilter {
                $Database -eq 'Test' -and
                $SqlInstance.ComputerName -eq 'Pester'
            }

            $params = @{
                Name = 'Test'
                Instance = 'Pester'
            }
        }

        It TriesNastyThings {
            Remove-AnnoyingDatabase @prms
            Should -Invoke -CommandName Remove-DbaDatabase -Times 1 -Exactly
        }

        It AvoidsTypos {
            Remove-AnnoyingDatabase @params
            Should -Invoke -CommandName Remove-DbaDatabase -Times 1 -Exactly
        }

    }
}