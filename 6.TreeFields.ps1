
# Define a PowerShell class for Field
class Field {
    static [bool] IsStandardTempalteField([Sitecore.Data.Templates.TemplateField]$field) {
        $template = Get-Item -Path "master:" | Get-ItemTemplate
        if (-not $template) {
            Write-Error "Template not found."
            return $false
        }
        return $template.ContainsField($field.ID)
    }
}

# Define the function to check rich text source field
# Call the function to check rich text source field
Write-Host "start"
    $multiList = @("treelist")

    $templates = [Sitecore.Data.Managers.TemplateManager]::GetTemplates([Sitecore.Data.Database]::GetDatabase("master"))

     
    foreach ($templatePair in $templates.GetEnumerator()) {
        foreach ($field in $templatePair.Value.GetFields($true) | Where-Object { $multiList -contains $_.TypeKey }) {
            if($templatePair.Value.FullName -notlike "System/*" -and $field.Name -notlike "__*") {
                $msg = "/sitecore/templates/$($templatePair.Value.FullName): Field Name $($field.Name), Type: $($field.Type),Source: $($field.Source)"
                Write-Host $msg
                # Add duplicate field to the list
                $issuesArray += $msg
            }
        }
    }
 





Write-Host "end"