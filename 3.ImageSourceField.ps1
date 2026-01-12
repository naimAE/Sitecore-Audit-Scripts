Add-Type -AssemblyName "Sitecore.Kernel"

function IsStandardTemplateField {
    param (
        [Sitecore.Data.Templates.TemplateField]$field
    )
    
    $template = [Sitecore.Data.Managers.TemplateManager]::GetTemplate(
        [Sitecore.Configuration.Settings]::DefaultBaseTemplate,
        [Sitecore.Data.Database]::GetDatabase("master")
    )
    
    [Sitecore.Diagnostics.Assert]::IsNotNull($template, "template")
    
    return $template.ContainsField($field.ID)
}

#function CheckImageSourceField {
    $multiList = @("image")

    $templates = [Sitecore.Data.Managers.TemplateManager]::GetTemplates([Sitecore.Data.Database]::GetDatabase("master"))

    foreach ($templatePair in $templates.GetEnumerator()) {
        foreach ($field in $templatePair.Value.GetFields($true) | Where-Object { $multiList -contains $_.TypeKey -and -not (IsStandardTemplateField $_) }) {
            if (-not $field.Source.Contains("core")) {
                Write-Host "/sitecore/templates/$($templatePair.Value.FullName) | Field [$($field.Name)] Source is empty: $($field.Source)"
            }
        }
    }
#}

Write-Host "Templates Image Field"

#CheckImageSourceField
