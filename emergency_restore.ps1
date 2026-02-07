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
        
        # 1. Remove the Cosmic HTML Block
        $c = $c -replace '(?s)<div id="universe-bg">.*?</div>', ''
        
        # 2. Remove the Cosmic CSS Block (looking for selectors)
        # We'll remove the entire styling block we added
        # It started with #universe-bg { ...
        $c = $c -replace '(?s)#universe-bg\s*\{.*?\}\s*', ''
        $c = $c -replace '(?s)\@keyframes deepSpace\s*\{.*?\}\s*', ''
        $c = $c -replace '(?s)\.stars-static\s*\{.*?\}\s*', ''
        $c = $c -replace '(?s)\@keyframes twinkle\s*\{.*?\}\s*', ''
        $c = $c -replace '(?s)\.shooting-star.*?\{.*?\}\s*', ''
        $c = $c -replace '(?s)\.shooting-star::before\s*\{.*?\}\s*', ''
        $c = $c -replace '(?s)\@keyframes animate\s*\{.*?\}\s*', ''
        # Remove individual timings
        $c = $c -replace '(?s)\.shooting-star:nth-child.*?\}', ''
        
        # 3. Remove the Body Override CSS
        $c = $c -replace '(?s)/\*\s*Override body for transparency.*?\*/.*?\}\s*', ''
        
        # 4. Remove any lingering <style> tags if we accidentally created empty ones or mess
        # (Skip for now to avoid breaking other styles)
        
        # 5. Restore the safe body style
        # We look for body { ... } again. Note that the override was technically separate or appended.
        # But if the original body rule was modified or we just want to be sure:
        if ($c -match '(?s)body\s*\{.*?\}') {
            $c = $c -replace '(?s)body\s*\{.*?\}', $cleanBodyStyle
        }
        
        # Remove any lingering "/* 🌌 DEEP COSMIC ANIMATION SYSTEM */" comments
        $c = $c -replace '/\*\s*🌌 DEEP COSMIC ANIMATION SYSTEM\s*\*/', ''

        Set-Content $file.FullName -Value $c -Encoding UTF8
        Write-Host "Restored $($file.Name)"
    }
    catch {
        Write-Error "Failed to restore $($file.Name): $_"
    }
}
Write-Host "✅ EMERGENCY RESTORE COMPLETE."
