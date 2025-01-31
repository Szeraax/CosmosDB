function Remove-CosmosDbDocument
{

    [CmdletBinding(DefaultParameterSetName = 'Context')]
    param
    (
        [Alias('Connection')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Context')]
        [ValidateNotNullOrEmpty()]
        [CosmosDb.Context]
        $Context,

        [Parameter(Mandatory = $true, ParameterSetName = 'Account')]
        [ValidateScript({ Assert-CosmosDbAccountNameValid -Name $_ -ArgumentName 'Account' })]
        [System.String]
        $Account,

        [Parameter()]
        [ValidateScript({ Assert-CosmosDbDatabaseIdValid -Id $_ -ArgumentName 'Database' })]
        [System.String]
        $Database,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Security.SecureString]
        $Key,

        [Parameter()]
        [ValidateSet('master', 'resource')]
        [System.String]
        $KeyType = 'master',

        [Parameter(Mandatory = $true)]
        [ValidateScript({ Assert-CosmosDbCollectionIdValid -Id $_ -ArgumentName 'CollectionId' })]
        [System.String]
        $CollectionId,

        [Parameter()]
        [ValidateScript({ Assert-CosmosDbDocumentIdValid -Id $_ })]
        [System.String]
        $Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Object[]]
        $PartitionKey,

        [Parameter()]
        [System.Int32]
        $MaximumRetryCount,

        [Parameter()]
        [System.Int32]
        $RetryIntervalSec = 5
    )

    $null = $PSBoundParameters.Remove('CollectionId')
    $null = $PSBoundParameters.Remove('Id')

    $resourcePath = ('colls/{0}/docs/{1}' -f $CollectionId, $Id)

    $headers = @{}

    if ($PSBoundParameters.ContainsKey('PartitionKey'))
    {
        $headers += @{
            'x-ms-documentdb-partitionkey' = Format-CosmosDbDocumentPartitionKey -PartitionKey $PartitionKey
        }
        $null = $PSBoundParameters.Remove('PartitionKey')
    }
    $invokeCosmosDbRequest_parameters = @{
        Method            = 'Delete'
        ResourceType      = 'docs'
        ResourcePath      = $resourcePath
        Headers           = $headers
        MaximumRetryCount = $MaximumRetryCount
        RetryIntervalSec  = $RetryIntervalSec
    }
    $null = Invoke-CosmosDbRequest @PSBoundParameters @invokeCosmosDbRequest_parameters
}
