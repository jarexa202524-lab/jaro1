$cleanBodyStyle = @'
    body {
      margin: 0;
      color: var(--text);
      font-family: "Rajdhani", sans-serif;
      background: #09050d;
      background-image:
        radial-gradient(circle at 10% 10%, rgba(138, 77, 255, 0.1) 0%, transparent 40%),
        radial-gradient(circle at 90% 90%, rgba(181, 139, 255, 0.05) 0%, transparent 40%);
      background-attachment: fixed;
      min-height: 100vh;
      overflow-x: hidden;
    }
'@

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    try {
        $c = Get-Content $file.FullName -Raw -Encoding UTF8
        
        # 1. Remove Star Layer HTML
        $c = $c -replace '(?s)<div class="star-layer">.*?</div>', ''
        
        # 2. Remove injected starfall CSS (escaped simple regex for safety)
        # We look for the comment we added or just specific class blocks
        $c = $c -replace '(?s)/\*\s*🌌 Gaming Starfall Animation\s*\*/.*?(?=</style>)', ''
        
        # 3. Remove Cyber/Aurora styles (pseudo-elements and keyframes)
        $c = $c -replace '(?s)body::before\s*\{.*?\}', ''
        $c = $c -replace '(?s)body::after\s*\{.*?\}', ''
        $c = $c -replace '(?s)@keyframes aurora\s*\{.*?\}', ''
        $c = $c -replace '(?s)@keyframes meteor\s*\{.*?\}', ''
        $c = $c -replace '(?s)@keyframes gradientBG\s*\{.*?\}', ''
        
        # 4. Clean up any leftover empty lines/artifacts from deletions
        # (Optional, but good for cleanliness)
        
        # 5. Restore Original Body Style
        # Replace the current body block with the clean static one
        if ($c -match '(?s)body\s*\{.*?\}') {
            $c = $c -replace '(?s)body\s*\{.*?\}', $cleanBodyStyle
            Write-Host "Restored clean body in $($file.Name)"
        }
        
        Set-Content $file.FullName -Value $c -Encoding UTF8
    }
    catch {
        Write-Error "Failed to revert $($file.Name): $_"
    }
}
Write-Host "✅ Site restored to clean Modernist v2.0 design."
