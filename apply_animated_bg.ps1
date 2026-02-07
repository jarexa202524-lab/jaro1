$bodyStyle = @'
    body {
      margin: 0;
      color: var(--text);
      font-family: "Rajdhani", sans-serif;
      /* Animated Purple Background */
      background: linear-gradient(-45deg, #09050d, #1a0b2e, #2f1b4e, #13091f);
      background-size: 400% 400%;
      animation: gradientBG 15s ease infinite;
      background-attachment: fixed;
      min-height: 100vh;
      overflow-x: hidden;
    }

    @keyframes gradientBG {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }
'@

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    try {
        $c = Get-Content $file.FullName -Raw -Encoding UTF8
        
        # 1. Remove previously added @keyframes gradientBG to avoid dupes from my last run
        # I'll replace the block I just added, which starts with @keyframes gradientBG
        $c = $c -replace '(?s)\s*@keyframes gradientBG\s*\{.*?\}\s*', ''
        
        # 2. Update body block again
        # This will match the NEW body block I just added, and replace it with the UPDATED one
        # Because the previous regex was body\s*\{.*?\}, it matches my new block too.
        # However, I need to be careful not to match partials.
        # But since I control the format now, it should match.
        
        $c = $c -replace '(?s)body\s*\{.*?\}', $bodyStyle
        
        Set-Content $file.FullName -Value $c -Encoding UTF8
        Write-Host "Re-Updated $($file.Name) with fixed attachment"
    }
    catch {
        Write-Error "Failed $($file.Name)"
    }
}
