
    $database = [Sitecore.Configuration.Factory]::GetDatabase("master")

    $templates = [Sitecore.Data.Managers.TemplateManager]::GetTemplates($database)
    $duplicates = @()

    foreach ($templatePair in $templates.GetEnumerator()) {
        $template = $templatePair.Value
        $fields = $template.GetFields($true)

        $groupedFields = $fields | Group-Object { $_.Key } | Where-Object { $_.Count -gt 1 }

        foreach ($group in $groupedFields) {
           
            $duplicates += "Field '$($group.Name)' duplicated from templates '$($group.Group.Template.FullName -join ", ")'"
        }
    }

Write-Host $duplicates