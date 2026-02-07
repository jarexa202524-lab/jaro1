$starfallCss = Get-Content "starfall.css" -Raw
$starfallHtml = @'
  <div class="star-layer">
    <div class="star"></div>
    <div class="star"></div>
    <div class="star"></div>
    <div class="star"></div>
    <div class="star"></div>
    <div class="star"></div>
    <div class="star"></div>
  </div>
'@

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    try {
        $c = Get-Content $file.FullName -Raw -Encoding UTF8
        
        # 1. Inject CSS if not present
        if (-not ($c -match "\.star-layer")) {
            # Add after body styling but before closing style tag
            # We use Regex to insert before </style>
            $c = $c -replace '(?s)(</style>)', ($starfallCss + "`n$1")
        }
        
        # 2. Inject HTML for stars if not present
        if (-not ($c -match '<div class="star-layer">')) {
            # Insert right after <body> tag opening
            $c = $c -replace '(<body.*?>)', "`$1`n  $starfallHtml"
        }
        else {
            # If already exists, replace it to ensure updated HTML structure (e.g. if I change star count)
            $c = $c -replace '(?s)<div class="star-layer">.*?</div>', $starfallHtml
        }

        Set-Content $file.FullName -Value $c -Encoding UTF8
        Write-Host "Injected Stars into $($file.Name)"
    }
    catch {
        Write-Error "Failed to process $($file.Name): $_"
    }
}
Write-Host "✅ Global Starfall Effect Applied."
