$logoCss = @'
    .logo {
      display: flex;
      flex-direction: column;
      text-decoration: none;
      line-height: 1.1;
    }

    .logo span {
'@

$files = @("awards.html", "can-i-run-it.html", "future-proof.html", "games.html", "hardware.html", "news.html", "reviews.html")

foreach ($file in $files) {
    if (Test-Path $file) {
        $c = Get-Content $file -Raw
        
        # Fix: .logo { span {  -> inserts correct .logo block and starts .logo span {
        if ($c -match '\.logo\s*\{\s*span\s*\{') {
            $c = $c -replace '\.logo\s*\{\s*span\s*\{', $logoCss
            Write-Host "Fixed logo in $file"
        }
        
        Set-Content $file $c -Encoding UTF8
    }
}
Write-Host "✅ Scan and fix complete."
