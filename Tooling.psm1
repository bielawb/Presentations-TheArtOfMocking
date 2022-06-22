function Add-FakeCommand {
    [CmdletBinding()]
    Param (
        $Name
    )

    $why = @'

                         ,---------------.
                        ( Why, Bartek...? )
                _     O  `---------------'
              ,'-`. o
              :_ _:
   ..._       \ _ /       _.,,
    `-.>.   _,-`-'-._   ,<,-'
      :  \ /    _    `./  ;
       \  `    '_)       /
        \  ,|  (_,  |.  /
         `' |   .   | `'
            :_______:


'@

    $script = [scriptblock]::Create(@"
function $Name {
    param (
        [String]`$Identity
    )
    Write-Warning "I'm not really $Name - just faking it here..."
    Start-Sleep -Second 1
    Write-Warning "Let's keep it a secret, OK...? Don't like - show it in front of the crowd or something..."
    Start-Sleep -Second 2
    Write-Warning "Hey, wait a minute!"
    Start-Sleep -Seconds 2
@'
$why
'@
}
Export-ModuleMember -Function $Name
"@)

    $script:mod = New-Module -ScriptBlock $script -Name $Name
    $script:mod | Import-Module -Scope Global
}

function New-PesterConfigurationEx {
    [CmdletBinding()]
    Param (
        [String]$Path
    )

    if (-not (Get-Module -Name Pester)) {
        Import-Module Pester -RequiredVersion 5.3.3
    }

    [PesterConfiguration]@{
        Output = @{
            Verbosity = 'Detailed'
            StackTraceVerbosity = 'FirstLine'
        }
        Run = @{
            Path = $Path
        }
    }
}