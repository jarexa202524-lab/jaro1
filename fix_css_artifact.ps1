# Fix duplicated keyframe syntax
$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    try {
        $c = Get-Content $file.FullName -Raw -Encoding UTF8
        
        # Regex to find the corrupted aurora keyframes block which has repeated lines
        $regex = '(?s)@keyframes aurora\s*\{.*?\}(\s*50%\s*\{\s*background-position:\s*100%\s*50%;\s*\}\s*100%\s*\{\s*background-position:\s*0%\s*50%;\s*\}){1,}\s*\}'
        
        if ($c -match $regex) {
            # Replace with clean block
            $cleanBlock = @'
    @keyframes aurora {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }
'@
            # We replace the entire matched corrupted block with the clean one
            # Note: The regex might be tricky. Let's try a simpler replacement of the whole body/keyframes section if needed,
            # but for now let's try to target the specific duplication artifact.
            
            # Alternative: simpler replace of the specific artifact "50% { ... } }" appearing after the closing brace
            $c = $c -replace '(?s)\}\s*50% \{ background-position: 100% 50%; \}\s*100% \{ background-position: 0% 50%; \}\s*\}', '}'
            $c = $c -replace '(?s)\}\s*50% \{ background-position: 100% 50%; \}\s*100% \{ background-position: 0% 50%; \}\s*\}', '}' # run twice just in case
            
            Set-Content $file.FullName -Value $c -Encoding UTF8
            Write-Host "Fixed CSS Artifacts in $($file.Name)"
        }
    }
    catch {
        Write-Error "Failed $($file.Name)"
    }
}
