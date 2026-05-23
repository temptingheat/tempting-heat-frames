$folder = "F:\Tempting Heat Web\tempting-heat-frames\frames\section3_finley_desktop"
$digits = 4

Get-ChildItem -Path $folder -File -Filter "*.jpg" | ForEach-Object {
    $file = $_
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $extension = $file.Extension.ToLower()

    if ($baseName -match '(\d+)$') {
        $number = [int]$matches[1]
        $newName = "{0:D$digits}{1}" -f $number, $extension

        if ($file.Name -ne $newName) {
            Rename-Item -Path $file.FullName -NewName $newName
            Write-Host "$($file.Name) -> $newName"
        }
    }
}


$digits = 4
$counter = 1

$files = Get-ChildItem -Path $folder -File -Filter "*.jpg" | Sort-Object Name

# Paso 1: renombrar temporalmente para evitar conflictos
foreach ($file in $files) {
    $tempName = "__temp__$($file.Name)"
    Rename-Item -Path $file.FullName -NewName $tempName
}

# Paso 2: renombrar en secuencia desde 0001
$counter = 1

Get-ChildItem -Path $folder -File -Filter "__temp__*.jpg" |
    Sort-Object Name |
    ForEach-Object {
        $newName = "{0:D$digits}{1}" -f $counter, $_.Extension.ToLower()
        Rename-Item -Path $_.FullName -NewName $newName
        Write-Host "$($_.Name) -> $newName"
        $counter++
    }