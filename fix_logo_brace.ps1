$files = @("awards.html", "can-i-run-it.html", "future-proof.html", "games.html", "hardware.html", "news.html", "reviews.html")

foreach ($file in $files) {
    if (Test-Path $file) {
        $c = Get-Content $file -Raw
        # Replace the double brace error introduced by previous script
        $c = $c -replace '\.logo \{\s*\{', ".logo {"
        # Also handle any cases where the first brace might be on a new line
        $c = $c -replace '\.logo\s*\{\s*\{', ".logo {"
        
        Set-Content $file $c -Encoding UTF8
    }
}
Write-Host "✅ Fixed double brace syntax error in .logo CSS."
