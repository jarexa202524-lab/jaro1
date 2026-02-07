$modernStylesPart = @'
    /* MODERNIST FLOATING OVAL TOPBAR */
    .topbar {
      position: sticky;
      top: 20px;
      z-index: 1000;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 12px 40px;
      width: calc(100% - 60px);
      max-width: 1400px;
      margin: 20px auto;
      background: rgba(15, 10, 25, 0.7);
      backdrop-filter: blur(30px) saturate(180%);
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 100px; /* Oval Style */
      box-shadow: 
        0 10px 40px rgba(0, 0, 0, 0.4),
        inset 0 1px 1px rgba(255, 255, 255, 0.05);
      transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .topbar.scrolled {
      top: 10px;
      padding: 8px 40px;
      background: rgba(15, 10, 25, 0.9);
      width: calc(100% - 40px);
      box-shadow: 0 15px 50px rgba(0, 0, 0, 0.6);
    }
'@

$files = @("awards.html", "can-i-run-it.html", "future-proof.html", "games.html", "hardware.html", "news.html", "reviews.html")

foreach ($file in $files) {
    if (Test-Path $file) {
        $c = Get-Content $file -Raw
        
        # Replace Topbar CSS (handles both .topbar and .topbar.scrolled if present)
        # We look for the comment or the specific class and replace the block
        if ($c -match '/\* MODERNIST TOPBAR \*/') {
            $c = $c -replace '(?s)/\* MODERNIST TOPBAR \*/.*?(\.logo|body)', ($modernStylesPart + "`r`n`r`n    $1")
        }
        elseif ($c -match '/\* MODERNIST FLOATING OVAL TOPBAR \*/') {
            $c = $c -replace '(?s)/\* MODERNIST FLOATING OVAL TOPBAR \*/.*?(\.logo|body)', ($modernStylesPart + "`r`n`r`n    $1")
        }
        else {
            # Fallback for simpler matches
            $c = $c -replace '(?s)\.topbar \{.*?\s*\}', $modernStylesPart
        }
        
        Set-Content $file $c -Encoding UTF8
    }
}
Write-Host "✅ Global Oval Style Applied."
