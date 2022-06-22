#region DPS

throw "Hey, Dory! Forgot to use F8?"

#endregion

#region predictable results

Invoke-Pester -Configuration (New-PesterConfigurationEx -Path GetDate.Tests.ps1)

#endregion

#region avoid changing

function Remove-Something {
    [CmdletBinding()]
    Param ()

    Remove-Item -Path C:\Windows -WhatIf
}

Invoke-Pester -Configuration (New-PesterConfigurationEx -Path Remove-Something.Tests.ps1)

#endregion

#region build fake worlds
function Remove-Database {
    [CmdletBinding()]
    Param (
        [String]$Name
    )

    $database = Get-DbaDatabase -Database $Name -SqlInstance ForPester
    Remove-DbaDatabase -Database $database.Database -SqlInstance $database.SqlInstance
}

Invoke-Pester -Configuration (New-PesterConfigurationEx -Path Remove-Database.Tests.ps1)

#endregion
