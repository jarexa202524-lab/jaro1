$cosmicCss = Get-Content "cosmic.css" -Raw
$bgHtml = @'
  <div id="universe-bg">
    <div class="stars-static"></div>
    <div class="shooting-star"></div>
    <div class="shooting-star"></div>
    <div class="shooting-star"></div>
    <div class="shooting-star"></div>
  </div>
'@

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    try {
        $c = Get-Content $file.FullName -Raw -Encoding UTF8
        
        # 1. Clean up old star-layer or existing universe-bg if any
        $c = $c -replace '(?s)<div class="star-layer">.*?</div>', ''
        $c = $c -replace '(?s)<div id="universe-bg">.*?</div>', ''
        
        # 2. Inject CSS
        # Check if already has styles
        if (-not ($c -match "\#universe-bg")) {
            $c = $c -replace '(?s)(</style>)', ($cosmicCss + "`n$1")
        }
        
        # 3. Inject HTML Wrapper right after body tag
        $c = $c -replace '(<body.*?>)', "`$1`n  $bgHtml"
        
        # 4. Ensure body is transparent so background shows through
        # We find the 'background:' or 'background-color:' inside body { ... } and remove it or set to transparent
        # A simple approach is to append an overriding rule at the end of the <style> block
        # Or modify the existing body rule. Let's make body transparent explicitly.
        
        $transparentBody = @'
    
    /* Override body for transparency to show universe-bg */
    body {
      background: transparent !important;
      background-image: none !important;
      position: relative; 
      z-index: 1; /* Content sits above background */
    }
'@
        $c = $c -replace '(?s)(</style>)', ($transparentBody + "`n$1")

        Set-Content $file.FullName -Value $c -Encoding UTF8
        Write-Host "Applied Cosmic Universe to $($file.Name)"
    }
    catch {
        Write-Error "Failed $($file.Name)"
    }
}
Write-Host "✅ Global Cosmic Animation Deployed."
