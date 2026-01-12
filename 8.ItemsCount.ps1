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
        # Get children items
        $items = $item.Children
        
        if ($items -ne $null) {
            if ($script:max -lt $items.Count) {
                $script:max = $items.Count
                $script:maxItemPath = $item.Paths.FullPath
            }
            
            if ($items.Count -gt 100) {
                $level++
                $childrens += $items.Count
                
                Write-Host ("{0} Item [{1}] - Children Count {2} " -f ('-' * $level), $item.Paths.FullPath, $items.Count)

                
            }
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
    
        $homepage = Get-Item -Path "master:" -ID "{0DE95AE4-41AB-4D01-9EB0-67441B7C2450}" # Assuming this is the home item ID

        # Get children count recursively
        $childrens = GetChildrens -item $homepage


        # Write max children count and path
        Write-Host ("Max Childrens count: {0}, Item [{1}] " -f $script:max, $script:maxItemPath)

        # Write total children count
        Write-Host ("Total Childrens Found: {0} " -f $childrens)

}

# Call GetItemCount function
GetItemCount
