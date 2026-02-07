$modernBgCss = @'
    /* MODERN ANIMATED BACKGROUND */
    #modern-background {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      z-index: -999;
      background: linear-gradient(-45deg, #050208, #10051f, #240c42, #0d041c);
      background-size: 400% 400%;
      animation: modernGradient 15s ease infinite;
      pointer-events: none;
    }

    /* Subtle Overlay Texture */
    #modern-background::after {
      content: "";
      position: absolute;
      inset: 0;
      background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)' opacity='0.03'/%3E%3C/svg%3E");
      opacity: 0.4;
    }

    @keyframes modernGradient {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }
    
    /* Ensure content sits above */
    body {
      background: transparent !important;
      position: relative;
      z-index: 1;
    }
'@

$bgHtml = '<div id="modern-background"></div>'

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    try {
        $c = Get-Content $file.FullName -Raw -Encoding UTF8
        
        # 1. Cleanup old background leftovers if any match known patterns
        $c = $c -replace '(?s)<div id="universe-bg">.*?</div>', ''
        $c = $c -replace '(?s)<div id="modern-background">.*?</div>', '' # prevent duplicates
        
        # 2. Inject CSS
        # We append to end of <style>
        if ($c -match '</style>') {
            # Check if CSS already exists to avoid duplication
            if (-not ($c -match '#modern-background')) {
                $c = $c -replace '(?s)(</style>)', ($modernBgCss + "`n$1")
            }
        }
        
        # 3. Inject HTML after body
        if ($c -match '<body.*?>') {
            $c = $c -replace '(<body.*?>)', "`$1`n  $bgHtml"
        }
        
        Set-Content $file.FullName -Value $c -Encoding UTF8
        Write-Host "Applied Modern BG to: $($file.Name)"
    }
    catch {
        Write-Error "Failed $($file.Name): $_"
    }
}
Write-Host "✅ Modern Animated Background Applied."
