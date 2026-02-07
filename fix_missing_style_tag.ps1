$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    $c = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # Check if </style> is missing but <style> exists
    if (($c -match '<style>') -and (-not ($c -match '</style>'))) {
        # We need to insert </style> before </head>
        # But we also injected CSS that ends with "z-index: 1;     }"
        # Let's verify where to put it. Usually before </head>.
        
        if ($c -match '</head>') {
            $c = $c -replace '(?s)\s*(</head>)', "`n  </style>`n`$1"
            Set-Content $file.FullName -Value $c -Encoding UTF8
            Write-Host "Fixed missing </style> in $($file.Name)"
        }
        else {
            Write-Warning "Could not find </head> in $($file.Name)"
        }
    }
    else {
        Write-Host "File $($file.Name) seems fine or has no style tag."
    }
}
