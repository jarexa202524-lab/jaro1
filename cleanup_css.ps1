# GAME DEBATE - CSS CLEANUP & REPAIR

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    $c = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # Remove any broken media queries (missing the opener but having the content)
    # This specifically targets the mess left behind by partial regex matches
    $c = $c -replace '(?s)\s*\{\s*\.topbar\s*\{\s*padding:\s*15px\s*20px;\s*\}\s*\.nav\s*\{\s*display:\s*none;\s*\}\s*\}', ''
    
    # Ensure no double </style> tags
    $c = $c -replace '(</style>\s*){2,}', "</style>`n"

    Set-Content $file.FullName -Value $c -Encoding UTF8
}
Write-Host "✅ CSS Cleanup Complete."
