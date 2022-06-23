#region DPS

throw "Hey, Dory! Forgot to use F8?"

#endregion

#region missing command, a.k.a. "it works on my machine"

Get-ADUser

function Get-UserInfo {
    [CmdletBinding()]
    param (
        [String]$Name
    )

    $ad = Get-ADUser -Identity $Name -Property displayName
    $userQuery = 'SELECT Name, ID FROM [HR].[Users] WHERE Name = "{0}"' -f $Name
    $sql = Invoke-DbaQuery -SqlInstance HR -Query $userQuery
    [PSCustomObject]@{
        Name = $ad.DisplayName
        Login = $ad.SamAccountName
        DBID = $sql.ID
    }
}

Invoke-Pester -Configuration (New-PesterConfigurationEx -Path Get-UserInfo.Tests.ps1)

Add-FakeCommand -Name Get-ADUser

Get-ADUser

Invoke-Pester -Configuration (New-PesterConfigurationEx -Path Get-UserInfo.Tests.ps1)

Remove-Item function:Get-ADUser

Get-ADUser

#endregion

#region mocking mock

Invoke-Pester -Configuration (New-PesterConfigurationEx -Path GetDataCircular.Tests.ps1)
#endregion

#region pipe wants objects

Get-Disk | Get-Partition
Trace-Command -Name ParameterBinding -Expression { Get-Disk | Get-Partition } -PSHost
<#
DEBUG: ParameterBinding Information: 0 :         BIND arg [MSFT_Disk (ObjectId = "{1}\\DESKTOP-2CF8TC1\root/Microsoft/Win...)] to parameter [Disk]
DEBUG: ParameterBinding Information: 0 :             Executing DATA GENERATION metadata: [System.Management.Automation.ArgumentTypeConverterAttribute]
DEBUG: ParameterBinding Information: 0 :                 result returned from DATA GENERATION: MSFT_Disk (ObjectId = "{1}\\DESKTOP-2CF8TC1\root/Microsoft/Win...)
DEBUG: ParameterBinding Information: 0 :             Executing VALIDATION metadata: [System.Management.Automation.ValidateNotNullAttribute]
DEBUG: ParameterBinding Information: 0 :             BIND arg [MSFT_Disk (ObjectId = "{1}\\DESKTOP-2CF8TC1\root/Microsoft/Win...)] to param [Disk] SUCCESSFUL
#>

function Get-DiskInfo {
    param (
        [Int]$DiskNumber
    )

    $disk = Get-Disk -Number $DiskNumber
    $partitions = @(Get-Disk -Number $DiskNumber | Get-Partition -ErrorAction Stop)

    [PScustomObject]@{
        Name = $disk.FriendlyName
        SerialNumber = $disk.SerialNumber
        Model = $disk.Model
        Partitions = $partitions
    }
}

Invoke-Pester -Configuration (New-PesterConfigurationEx -Path Get-DiskInfo.Tests.ps1)

#endregion

#region "try to mock me!" challenge

function Find-ADObject {
    param (
        [string[]]$Filter,            
        [string[]]$Properties
    )

    $ldapFilter = "(&({0}))" -f ($Filter -join ')(')

    $searcher = [adsisearcher]::new(
        [ADSI]'',
        $ldapFilter,
        $Properties
    )

    $searcher.FindAll()
}

#endregion