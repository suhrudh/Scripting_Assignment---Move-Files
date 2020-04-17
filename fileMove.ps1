function fileMove([string]$src,[string]$dest1,[string]$dest2)
{
$full_set = Get-ChildItem -LiteralPath $src -File
if(($full_set).count -eq 0)
{
Write-Warning "No files to be moved or deleted"
return $false
}else{
$full_set| Where-Object {$_.Name -match "^[a-l]"} | Move-Item -Destination $dest1
$full_set| Where-Object {$_.Name -match "^[m-z]"} | Move-Item -Destination $dest2
Get-ChildItem -LiteralPath $src -File |Remove-Item
return $true
}
}