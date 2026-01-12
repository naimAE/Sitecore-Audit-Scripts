        $homepage = Get-Item -Path "master:" -ID "{0DE95AE4-41AB-4D01-9EB0-67441B7C2450}" # Assuming this is the home item ID

        # Get children count recursively
        $childrens = GetChildrens -item $homepage -level $level

  $homepage1 = Get-Item -Path "master:" -ID "{0B56FE5F-14F2-4096-BD5B-11DC806AE956}"
 
# Define numeric values for inheritance types
$level = 0
$inheritanceNone = [Sitecore.Security.AccessControl.SecurityPermission]::DenyInheritance;
# Write-Host [Sitecore.Security.AccessControl.SecurityPermission]::None;
# Write-Host [Sitecore.Security.AccessControl.SecurityPermission]::DenyInheritance;
# GetChildrens  -item $currentItem -level $level

function GetChildrens {
    param (
        [Sitecore.Data.Items.Item]$item,
        [int]$level = 0
    )
    

    # Initialize children count

    if ($item -ne $null) {
        # Get children items
        $items = $item.Children
        
        if ($items -ne $null) {

            foreach ($child in $items.GetEnumerator()) {
                
                    $inheritanceType = $child.Security.GetAccessRules().PermissionType

                    if ($inheritanceType -eq $inheritanceNone) {
                          Write-Host "Inheritance is broken for $($currentItem.Paths.FullPath). Access rights are explicitly defined for this item."
                    } 
                    
                   GetChildrens -item $child -level $level
                }
        }
    }
}