Add-Type -AssemblyName "Sitecore.Kernel"

function GetMultiFields {
    $multiList = @("multilist", "treelist", "treelistex")

    $templates = [Sitecore.Data.Managers.TemplateManager]::GetTemplates([Sitecore.Data.Database]::GetDatabase("master"))

    $issuesArray = @()

    foreach ($templatePair in $templates.GetEnumerator()) {
        foreach ($field in $templatePair.Value.GetFields($true) | Where-Object { $multiList -contains $_.TypeKey -and [string]::IsNullOrEmpty($_.Source) }) {
            if($templatePair.Value.FullName -notlike "System/*") {
                $msg = "/sitecore/templates/$($templatePair.Value.FullName): Field Name $($field.Name), Type $($field.Type) $($field.Source)"
                Write-Host $msg
                # Add duplicate field to the list
                $issuesArray += $msg
            }
        }
    }

    return $issuesArray
}

Write-Host "Fields with issues Found: $((GetMultiFields).Count)"
