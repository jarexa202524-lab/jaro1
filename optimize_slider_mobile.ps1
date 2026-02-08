# SCRIPT TO OPTIMIZE SLIDER FOR MOBILE
$files = Get-ChildItem -Path . -Filter *.html

$mobileSliderCss = @"
@media (max-width: 600px) {
    .hero-container { padding: 10px !important; }
    .slider-wrapper { height: 400px !important; border-radius: 20px !important; }
    .slide { background-position: center 20% !important; } /* Focus on the character's upper body */
    .slide-content { left: 20px !important; bottom: 30px !important; width: calc(100% - 40px) !important; }
    .slide-title { font-size: 32px !important; margin-bottom: 5px !important; }
    .slide-desc { font-size: 14px !important; line-height: 1.4 !important; }
}
"@

foreach ($file in $files) {
    $c = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    if ($c -match '</style>') {
        # Check if already optimized to avoid duplication
        if ($c -notmatch 'Focus on the character''s upper body') {
            $c = $c.Replace('</style>', "$mobileSliderCss`n</style>")
            $utf8NoBom = New-Object System.Text.UTF8Encoding $false
            [System.IO.File]::WriteAllText($file.FullName, $c, $utf8NoBom)
            Write-Host "Slider optimized for: $($file.Name)"
        }
    }
}
