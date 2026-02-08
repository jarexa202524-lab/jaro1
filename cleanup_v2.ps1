$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    if (Test-Path $file.FullName) {
        $content = Get-Content $file.FullName -Raw
        
        # This matches the specific fragmented pattern we see
        $pattern = '(?s)\n\s*@media\s*\(max-width:\s*1100px\)\s*\{\s*\}' # Handle empty media query if it left one
        $content = $content -replace $pattern, ""
        
        # Target the specifically broken block
        $brokenBlock = '(?s)\n\s*\{\s*\.topbar\s*\{\s*padding:\s*15px\s*20px;\s*\}\s*\.nav\s*\{\s*display:\s*none;\s*\}\s*\}'
        $content = $content -replace $brokenBlock, ""
        
        # More generic cleanup for any @media query that lost its opener
        $content = $content -replace '(?s)\n\s+\.topbar\s+\{\n\s+padding:\s+15px\s+20px;\n\s+\}\n\n\s+\.nav\s+\{\n\s+display:\s+none;\n\s+\}\n\s+\}', ""

        Set-Content $file.FullName $content -Encoding UTF8
    }
}
Write-Host "Cleanup Finalized."
