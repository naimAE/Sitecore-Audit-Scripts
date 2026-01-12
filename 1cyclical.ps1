function Get-CyclicallyInheritedTemplates {
    param (
        [string]$databaseName = "master"
    )

    # Load Sitecore assemblies
    Add-Type -AssemblyName "Sitecore.Kernel"

    # Initialize result list
    $resultPairs = New-Object System.Collections.Generic.List[Object]

    # Get the database
    $database = [Sitecore.Configuration.Factory]::GetDatabase($databaseName)

    # Function to check cyclic inheritance
    function CheckInBaseTemplates($result, $currentTemplatePath, $templateInitiator, $inheritanceChain) {
        $templateItem = [Sitecore.Data.Managers.TemplateManager]::GetTemplate($currentTemplatePath, $database)
        $templateInitiatorItem = [Sitecore.Data.Managers.TemplateManager]::GetTemplate($templateInitiator, $database)

        if ($templateItem -ne $null) {
            $inheritanceChainUpdated = "{0} <-- {1}" -f $inheritanceChain, $templateItem.Name
            

            $foundMatches = $templateItem.BaseIDs | Where-Object { $_.ToString().Equals($templateInitiator, [System.StringComparison]::InvariantCultureIgnoreCase) } |
                ForEach-Object {
                    New-Object Pairstring, string
                }

            if ($foundMatches.Count -gt 0) {
                Write-Host $inheritanceChainUpdated $foundMatches[0]
                $result.Add($foundMatches[0])
            }

            foreach ($baseTemplate in $templateItem.BaseIDs) {
                # Check to avoid infinite recursion
                if ($baseTemplate.ToString().Equals($templateInitiator)) {
                    continue
                }

                $result = CheckInBaseTemplates $result $baseTemplate.ToString() $templateInitiator $inheritanceChainUpdated
            }
        }

        return $result
    }

    # Get all templates
    $templates = [Sitecore.Data.Managers.TemplateManager]::GetTemplates($database)

    # Process each template
    foreach ($template in $templates) {
        $resultPairs = CheckInBaseTemplates $resultPairs $template.Key.ToString() $template.Key.ToString() ""
    }
    
    Write-Host  $resultPairs
    return $resultPairs
}

Write-Host "start"
Get-CyclicallyInheritedTemplates
Write-Host "end"