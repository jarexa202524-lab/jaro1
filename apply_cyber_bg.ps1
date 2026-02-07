$cssBlock = @'
    body {
      margin: 0;
      color: var(--text);
      font-family: "Rajdhani", sans-serif;
      min-height: 100vh;
      overflow-x: hidden;
      position: relative;
      background-color: #09050d; /* Fallback */
    }

    /* 1. Deep Animated Gradient Layer */
    body::before {
      content: "";
      position: fixed;
      inset: 0;
      z-index: -2;
      background: linear-gradient(135deg, #09050d 0%, #1a0b2e 25%, #2f1b4e 50%, #13091f 75%, #09050d 100%);
      background-size: 400% 400%;
      animation: aurora 15s ease infinite;
    }

    /* 2. Cyber Grid Overlay with Fade Effect */
    body::after {
      content: "";
      position: fixed;
      inset: 0;
      z-index: -1;
      background-image: 
        linear-gradient(rgba(138, 77, 255, 0.05) 1px, transparent 1px),
        linear-gradient(90deg, rgba(138, 77, 255, 0.05) 1px, transparent 1px);
      background-size: 40px 40px;
      pointer-events: none;
      mask-image: radial-gradient(circle at center, black 30%, transparent 80%);
      -webkit-mask-image: radial-gradient(circle at center, black 30%, transparent 80%);
    }

    @keyframes aurora {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }
'@

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    $c = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # Remove old keyframes if present
    $c = $c -replace '(?s)\s*@keyframes gradientBG\s*\{.*?\}\s*', ''
    $c = $c -replace '(?s)\s*@keyframes aurora\s*\{.*?\}\s*', ''
    
    # Replace body block
    # We use a pattern that matches body { ... } 
    # and we append the new CSS block which contains body{}, body::before{}, body::after{}, and keyframes
    if ($c -match '(?s)body\s*\{.*?\}') {
        $c = $c -replace '(?s)body\s*\{.*?\}', $cssBlock
        Set-Content $file.FullName -Value $c -Encoding UTF8
        Write-Host "Enhanced Background: $($file.Name)"
    }
}
