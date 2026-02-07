$modernStylesPart = @'
    /* MODERNIST FLOATING OVAL TOPBAR */
    .topbar {
      position: sticky;
      top: 20px;
      z-index: 1000;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 10px 40px;
      width: 95%;
      max-width: 1400px;
      margin: 0 auto;
      background: rgba(15, 10, 25, 0.75);
      backdrop-filter: blur(30px) saturate(180%);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 60px; /* Modern Oval */
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
      transition: all 0.6s cubic-bezier(0.16, 1, 0.3, 1);
    }

    .topbar.scrolled {
      top: 10px;
      padding: 6px 40px;
      background: rgba(15, 10, 25, 0.95);
      width: 98%;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.6);
    }

    .logo {
'@

$files = @("awards.html", "can-i-run-it.html", "future-proof.html", "games.html", "hardware.html", "news.html", "reviews.html")

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        # Regex to match from .topbar { (including potential comment above) 
        # until the start of the logo block (either .logo or the mark class)
        $pattern = '(?s)(/\*.*?\*/\s*)?\.topbar\s*\{.*?\.topbar\.scrolled\s*\{.*?\}(\s*|(?=\.logo))'
        
        if ($content -match $pattern) {
            $content = $content -replace $pattern, ($modernStylesPart + " ")
        }
        else {
            # Fallback if the scrolled block isn't present or name is different
            $content = $content -replace '(?s)\.topbar\s*\{.*?\}', $modernStylesPart
        }
        
        # Specific fix for the "clipped" logo class
        $content = $content -replace '(\n\s*)\{\s*\n', "`$1.logo {`n"

        Set-Content $file $content -Encoding UTF8
    }
}
Write-Host "✅ Global Oval Style Applied Robustly."
