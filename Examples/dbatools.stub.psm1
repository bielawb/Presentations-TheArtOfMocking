function Attach-DbaDatabase {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [System.Object[]]
        ${SqlInstance},

        [Parameter(Position=1)]
        [System.Object]
        [System.Management.Automation.CredentialAttribute()]
        ${SqlCredential},

        [Parameter(Mandatory=$true, Position=2)]
        [string[]]
        ${Database},

        [Parameter(Position=3)]
        [System.Object]
        ${FileStructure},

        [Parameter(Position=4)]
        [string]
        ${DatabaseOwner},

        [Parameter(Position=5)]
        [ValidateSet('None','RebuildLog','EnableBroker','NewBroker','ErrorBrokerConversations')]
        [string]
        ${AttachOption},

        [switch]
        ${EnableException}
    )
    throw 'Throwing from Attach-DbaDatabase - please mock me!'
}
function Detach-DbaDatabase {
    [CmdletBinding(DefaultParameterSetName='Default', SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    param (
        [Parameter(ParameterSetName='SqlInstance', Mandatory=$true)]
        [System.Object[]]
        ${SqlInstance},

        [System.Object]
        [System.Management.Automation.CredentialAttribute()]
        ${SqlCredential},

        [Parameter(ParameterSetName='SqlInstance', Mandatory=$true)]
        [string[]]
        ${Database},

        [Parameter(ParameterSetName='Pipeline', Mandatory=$true, ValueFromPipeline=$true)]
        [System.Object[]]
        ${InputObject},

        [switch]
        ${UpdateStatistics},

        [switch]
        ${Force},

        [switch]
        ${EnableException}
    )
    throw 'Throwing from Detach-DbaDatabase - please mock me!'
}
function Get-DbaDbModule {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [System.Object[]]
        ${SqlInstance},

        [Parameter(Position=1)]
        [System.Object]
        [System.Management.Automation.CredentialAttribute()]
        ${SqlCredential},

        [Parameter(Position=2)]
        [System.Object[]]
        ${Database},

        [Parameter(Position=3)]
        [System.Object[]]
        ${ExcludeDatabase},

        [Parameter(Position=4)]
        [datetime]
        ${ModifiedSince},

        [Parameter(Position=5)]
        [ValidateSet('View','TableValuedFunction','DefaultConstraint','StoredProcedure','Rule','InlineTableValuedFunction','Trigger','ScalarFunction')]
        [string[]]
        ${Type},

        [switch]
        ${ExcludeSystemDatabases},

        [switch]
        ${ExcludeSystemObjects},

        [Parameter(Position=6, ValueFromPipeline=$true)]
        [System.Object[]]
        ${InputObject},

        [switch]
        ${EnableException}
    )
    throw 'Throwing from Get-DbaDbModule - please mock me!'
}
