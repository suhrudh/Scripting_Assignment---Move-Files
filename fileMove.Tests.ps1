$here = Get-Location
. $here\fileMove.ps1

Describe 'fileMove' {
    New-Item -Path $here -Name "Source" -ItemType Directory
    New-Item -Path $here -Name "Destination1" -ItemType Directory
    New-Item -Path $here -Name "Destination2" -ItemType Directory
    
    $src1 = "$(Get-Location)\Source" 
    $dest3 = "$(Get-Location)\Destination1" 
    $dest4 = "$(Get-Location)\Destination2"
    It 'No files at Source Directory' {
        $ans = fileMove -src $src1  -dest1 $dest3 -dest2 $dest4
        $ans | should Be False
    }

    
    It '(apple.txt,pear.txt,1234.txt) Files Present at source directory' {
        
        New-Item -Path "$here\Source" -Name "apple.txt" -ItemType File
        New-Item -Path "$here\Source" -Name "pear.txt" -ItemType File
        New-Item -Path "$here\Source" -Name "123.txt" -ItemType File

        $ans =fileMove -src $src1 -dest1 $dest3 -dest2 $dest4
        $ans | should Be True

        #checking for empty source file - Deletes 123.txt, so empty
        $childAtSource = Get-ChildItem -LiteralPath $src1 -File
        ($childAtSource).Count | should Be 0

        #checking for destination1 file - finds apple.txt
        $childAtDestination1 = Get-ChildItem -LiteralPath $dest3 -File
        ($childAtDestination1).Count | should Be 1
        ($childAtDestination1 | Where-Object{$_.Name -eq "apple.txt"}).Count |should Be 1

        #checking for destination2 file - finds pear.txt
        $childAtDestination2 = Get-ChildItem -LiteralPath $dest4 -File
        ($childAtDestination2).Count | should Be 1
        ($childAtDestination2 | Where-Object{$_.Name -eq "pear.txt"}).Count |should Be 1

        Get-ChildItem -LiteralPath $dest3 -File | Remove-Item -Recurse
        Get-ChildItem -LiteralPath $dest4 -File | Remove-Item -Recurse

    }

    It '(apple.txt.bobcat.txt) File Present at source directory' {
        
        New-Item -Path "$here\Source" -Name "apple.txt. bobcat.txt" -ItemType File

        $ans =fileMove -src $src1 -dest1 $dest3 -dest2 $dest4
        $ans | should Be True

        #checking for empty source file - Deletes 123.txt, so empty
        $childAtSource = Get-ChildItem -LiteralPath $src1 -File
        ($childAtSource).Count | should Be 0

        #checking for destination1 file - finds apple.txt
        $childAtDestination1 = Get-ChildItem -LiteralPath $dest3 -File
        ($childAtDestination1).Count | should Be 1
        ($childAtDestination1 | Where-Object{$_.Name -eq "apple.txt. bobcat.txt"}).Count |should Be 1
    }


    Get-ChildItem -Directory | Remove-Item -Recurse
}