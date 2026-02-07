$bodyStyle = @'
    body {
      margin: 0;
      color: var(--text);
      font-family: "Rajdhani", sans-serif;
      /* Animated Purple Background */
      background: linear-gradient(-45deg, #09050d, #1a0b2e, #2f1b4e, #13091f);
      background-size: 400% 400%;
      animation: gradientBG 12s ease infinite;
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
        
        # 1. Remove existing @keyframes gradientBG if present
        $c = $c -replace '(?s)\s*@keyframes gradientBG\s*\{.*?\}\s*', ''
        
        # 2. Replace body { ... } block with new animated version
        # We use regex to match the body selector and its content
        if ($c -match '(?s)body\s*\{.*?\}') {
            # We replace only the body block, and append the keyframes right after
            # However, since $bodyStyle includes the keyframes, we just substitute
            $c = $c -replace '(?s)body\s*\{.*?\}', $bodyStyle
            
            Set-Content $file.FullName -Value $c -Encoding UTF8
            Write-Host "Updated $($file.Name)"
        }
        else {
            Write-Warning "No body block found in $($file.Name)"
        }
    }
    catch {
        Write-Error "Failed to process $($file.Name): $_"
    }
}
