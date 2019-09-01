#Connect-AzureRmAccount
#Get list of Azure Subscription ID's
#$subscriptions = (get-AzureRMSubscription).ID

$subscriptions = @('Theatreers Dev')

foreach ($subscription in $subscriptions){
    Select-AzureRmSubscription -SubscriptionName $subscription
    $AllRGs = (Get-AzureRmResourceGroup).ResourceGroupName

    foreach ($resourceGroup in $AllRGs){

        $microservice = ($resourceGroup -split "-")[1]
        $environment = ($resourceGroup -split "-")[2]

        #$resources = Get-AzureRMResource -ResourceGroupName $resourceGroup
        
        Write-Output "Resources in $($resourceGroup) to be assigned tags $($microservice) and $($environment)"

        
        Write-Output "Setting $($resourceGroup) tags..."
        $tags = (Get-AzureRMResourceGroup -Name $resourceGroup).Tags

        if ($null -eq $tags){
            Set-AzResourceGroup -Name $resourceGroup -Tag @{ microservice=$microservice; environment=$environment }
        } else {
            $tags.Add("microservice", $microservice)
            $tags.Add("environment", $environment)
            Set-AzResourceGroup -Tag $tags -Name $resourceGroup  
        } 

        #foreach ($resource in $resources){
        #    Write-Output "Setting $($resource.Name) tags..."
        #    $r = Get-AzureRmResource -ResourceName $resource.Name -ResourceGroupName $resourceGroup
        #    $r.Tags.Add("microservice", $microservice)
        #    $r.Tags.Add("environment", $environment)
        #    Set-AzureRmResource -Tag $r.Tags -ResourceId $r.ResourceId -Force
        #}
    }
}
