# Define static variables
$script:max = 0
$script:maxItemPath = ""

# Define function to get children count recursively
function GetChildrens {
    param (
        [Sitecore.Data.Items.Item]$item,
        [int]$level = 0
    )

    # Initialize children count
    $childrens = 0
    
    if ($item -ne $null) {
        # Update max versions count and path if necessary
        if ($script:max -lt $item.Versions.Count) {
            $script:max = $item.Versions.Count
            $script:maxItemPath = $item.Paths.FullPath
        }
        
        # Write item information if versions count exceeds 10
        if ($item.Versions.Count -gt 10) {
            Write-Host ("{0} Item [{1}] - Version Count {2} " -f ('-' * $level), $item.Paths.FullPath, $item.Versions.Count)
        }
        
        # Get children items
        $items = $item.Children
        
        if ($items -ne $null) {
            $level++
            $childrens += $items.Count
            
            foreach ($child in $items) {
                $childrens += GetChildrens -item $child -level $level
            }
        }
    }
    
    return $childrens
}

# Define function to get item count
function GetItemCount {
    # Disable security

        # Get home item
        $homepage = Get-Item -Path "master:" -ID "{0DE95AE4-41AB-4D01-9EB0-67441B7C2450}" # Assuming this is the home item ID

        # Get children count recursively
        $childrens = GetChildrens -item $homepage

        # Write max versions count and path
        Write-Host ("Max Versions count: {0}, Item [{1}]<BR>" -f $script:max, $script:maxItemPath)

        # Write total children count
        Write-Host ("Total Childrens Found: {0}<BR>" -f $childrens)
  
}

# Call GetItemCount function
GetItemCount
