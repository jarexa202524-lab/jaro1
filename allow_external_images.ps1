# SCRIPT TO ALLOW ALL EXTERNAL IMAGES (Bypass Hotlink Protection)
$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    $c = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    if ($c -notmatch '<meta name="referrer" content="no-referrer" />') {
        if ($c -match '<head>') {
            $tag = '  <meta name="referrer" content="no-referrer" />'
            $c = $c.Replace('<head>', "<head>`n$tag")
            
            $utf8NoBom = New-Object System.Text.UTF8Encoding $false
            [System.IO.File]::WriteAllText($file.FullName, $c, $utf8NoBom)
            Write-Host "Allowed external images on: $($file.Name)"
        }
    }
}
