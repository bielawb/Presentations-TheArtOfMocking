#region DPS

throw "Hey, Dory! Forgot to use F8?"

#endregion

#region stub modules

function  Write-FunctionStub {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(
                Mandatory,
                ValueFromPipelineByPropertyName
        )]
        [ValidateScript(
                {
                    Get-Command -Name $_ -ErrorAction Stop
                    $true
                }
        )]
        [ArgumentCompleter(
                {
                    [System.Management.Automation.CompletionCompleters]::CompleteCommand(
                        "$($args[2])*",
                        '*',
                        [System.Management.Automation.CommandTypes]::Cmdlet
                    )
                }
        )]
        [String]$Name
    )

    process {
        $cmd = Get-Command -Name $Name
        $meta = [System.Management.Automation.CommandMetadata]::new($cmd)
        $commonParameters = @(
            'Verbose'
            'Debug'
            'ErrorAction'
            'WarningAction'
            'InformationAction'
            'ErrorVariable'
            'WarningVariable'
            'InformationVariable'
            'OutVariable'
            'OutBuffer'
            'PipelineVariable'
            'WhatIf'
            'Confirm'
        )
        Write-Verbose "Adding dynamic parameters (because AD) to the mix"
        $dynamicParams = $ExecutionContext.InvokeCommand.GetCommand($Name, $cmd.CommandType, $null)
        foreach ($dynamicParamKey in $dynamicParams.Parameters.Keys) {
            if ($dynamicParamKey -in $commonParameters) {
                continue
            }
            if (-not $meta.Parameters.ContainsKey($dynamicParamKey)) {
                $meta.Parameters.Add($dynamicParamKey, $dynamicParams.Parameters.$dynamicParamKey)
            }
        }

        foreach ($paramKey in $meta.Parameters.Keys) {
            $param = $meta.Parameters.$paramKey
            $paramType = $param.ParameterType

            if ($paramType.IsArray) {
                if ($paramType -notin [int[]], [string[]], [datetime[]]) {
                    Write-Warning "Replacing $($paramType.Name) with System.Object[]"
                    $param.ParameterType = [object[]]        
                }
            } else {
                if ($paramType -notin [int], [string], [switch], [bool], [datetime]) {
                    Write-Warning "Replacing type $($paramType.Name) with System.Object"
                    $param.ParameterType = [object]
                }
            }
        }
        #replace does: indent params with 8 lines; add a newline after each param
        $paramBlock = [System.Management.Automation.ProxyCommand]::GetParamBlock($meta) -replace '(?m)^\s+(?=\S)', (' ' * 8) -replace'(?m)},', "},`n"
@"
function $($cmd.Name) {
    $([System.Management.Automation.ProxyCommand]::GetCmdletBindingAttribute($meta))
    param (
$paramBlock
    )
    throw 'Throwing from $Name - please mock me!'
}
"@
    }
}

Get-Command -Module dbatools |
    Select-Object -First 3 |
    Write-FunctionStub |
    Set-Content -Path .\dbatools.stub.psm1 -PassThru

#endregion

#region catch-all mock + param-filter mocks

function Remove-AnnoyingDatabase {
    param (
        [String]$Name = 'SuperImportantDatabase',
        [String]$Instance = 'Prod'
    )
    Remove-DbaDatabase -SqlInstance $Instance -Database $Name -Confirm:$false
}

Invoke-Pester -Configuration (New-PesterConfigurationEx -Path Remove-AnnoyingDatabase.Tests.ps1)

#endregion

#region PSTypeNames and New-CimInstance

Get-Help -Name Get-Partition -Parameter Disk
(Get-Command Get-Partition).Parameters['Disk'].Attributes.Where{
    $_.TypeId -eq [System.Management.Automation.PSTypeNameAttribute]
}.PSTypeName

# Fake it with PSTypeNames

[PSCustomObject]@{
    PSTypeName = 'Microsoft.Management.Infrastructure.CimInstance#MSFT_Disk'
    Number = 1
    Size = 1PB
    FriendlyName = 'My Secret Disk'
    SerialNumber = '1234'
}

[PSCustomObject]@{
    PSTypeName = 'Microsoft.Management.Infrastructure.CimInstance#MSFT_Disk'
    Number = 1
    Size = 1PB
    FriendlyName = 'My Secret Disk'
    SerialNumber = '1234'
    PartitionStyle = 'GPT'
}

New-CimInstance -ClassName MSFT_Disk -Property @{
    Number = 42
    PartitionStyle = 2
    Size = 1PB
    FriendlyName = 'MyOtherSecretDisk'
} -Namespace root/Microsoft/Windows/Storage -ClientOnly

$cimError = New-CimInstance -ClientOnly -ClassName MSFT_WmiError -Property @{ error_Code = 9714 }
$exception = [Microsoft.Management.Infrastructure.CimException]::new($cimError)
Write-Error -Exception $exception

New-CImInstance -ClassName SMS_SoftwareUpdate -NameSpace root\sms\foo -ClientOnly -Property @{
    DateCreated = '01-01-2021'
    SDMPackageXML = '<xml/>'
}

#endregion

#region New-Object

function Find-ADObject {
    param (
        [string[]]$Filter,            
        [string[]]$Properties
    )

    $ldapFilter = "(&({0}))" -f ($Filter -join ')(')

    $root = New-Object -TypeName ADSI

    $searcher = New-Object -TypeName adsisearcher -ArgumentList @(
        $root
        $ldapFilter
        , $Properties
    )

    $searcher.FindAll() | ForEach-Object {
        $out = [ordered]@{}
        foreach ($property in $Properties) {
            $out[$property] = $_.properties[$property][0]
        }
        [PSCustomObject]$out
    }
}

Invoke-Pester -Configuration (New-PesterConfigurationEx -Path ADSI.Tests.ps1)

#endregion


#region Mocking non-existent classes

function Get-Foo {
    [foo.bar.whatever]::Boom
}

$pesterConfig = New-PesterConfiguration -Hashtable @{
    Run = @{
        ScriptBlock = {
            Describe QuickNDirty {
                BeforeAll {
                    class mine {
                        static $Boom = '2022-12-25'
                    }
                    $xlr8r = [psobject].assembly.gettype("System.Management.Automation.TypeAccelerators")
                    $xlr8r::Add('foo.bar.whatever', [mine])
                }
                It Works! {
                    Get-Foo | Should -BeExactly '2022-12-25'
                }
                }
        }
    }
}

Invoke-Pester -Configuration $pesterConfig

#endregion