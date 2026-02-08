# GAME DEBATE - GLOBAL RESPONSIVE OPTIMIZER

$responsiveCss = Get-Content "responsive.css" -Raw

$mobileMenuHtml = @'
  <!-- MOBILE MENU -->
  <div class="mobile-menu" id="mobileMenu">
    <a href="news.html">News</a>
    <a href="games.html">Games</a>
    <a href="hardware.html">Hardware</a>
    <a href="reviews.html">Reviews</a>
    <a href="awards.html">Awards</a>
    <a href="can-i-run-it.html">Can I Run It</a>
    <div style="margin-top: 40px; display: flex; gap: 15px;" id="mobileAuth">
      <!-- Auth buttons will be cloned here if needed -->
    </div>
  </div>
'@

$mobileToggleHtml = @'
    <div class="mobile-toggle" id="mobileToggle">
      <span></span>
      <span></span>
      <span></span>
    </div>
'@

$responsiveJs = @'
    // MOBILE MENU LOGIC
    const mobileToggle = document.getElementById('mobileToggle');
    const mobileMenu = document.getElementById('mobileMenu');
    const authSection = document.getElementById('authSection');
    const mobileAuth = document.getElementById('mobileAuth');

    if (mobileToggle && mobileMenu) {
      mobileToggle.onclick = () => {
        mobileToggle.classList.toggle('active');
        mobileMenu.classList.toggle('active');
        document.body.style.overflow = mobileMenu.classList.contains('active') ? 'hidden' : '';
        
        // Clone auth buttons to mobile menu if not already there
        if (authSection && mobileAuth && mobileAuth.children.length === 0) {
          mobileAuth.innerHTML = authSection.innerHTML;
        }
      };
      
      // Close menu on link click
      mobileMenu.querySelectorAll('a').forEach(link => {
        link.onclick = () => {
          mobileToggle.classList.remove('active');
          mobileMenu.classList.remove('active');
          document.body.style.overflow = '';
        };
      });
    }
'@

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    try {
        $c = Get-Content $file.FullName -Raw -Encoding UTF8
        
        # 1. Inject CSS
        if (-not ($c -match "UNIVERSAL RESPONSIVE SYSTEM")) {
            $c = $c -replace '(?s)(</style>)', ($responsiveCss + "`n$1")
        }
        
        # 2. Inject Mobile Menu HTML (right after <body> opening)
        if (-not ($c -match 'id="mobileMenu"')) {
            $c = $c -replace '(<body.*?>)', "`$1`n  $mobileMenuHtml"
        }
        
        # 3. Inject Mobile Toggle inside topbar (after auth section)
        if (-not ($c -match 'id="mobileToggle"')) {
            # Try to find the end of auth section or just before </header>
            if ($c -match 'id="authSection">.*?</div>') {
                $c = $c -replace '(id="authSection">.*?</div>)', "`$1`n    $mobileToggleHtml"
            }
            else {
                $c = $c -replace '(</header>)', "`n    $mobileToggleHtml`n$1"
            }
        }
        
        # 4. Inject JS Logic
        if (-not ($c -match "MOBILE MENU LOGIC")) {
            if ($c -match '</script>') {
                # Find the LAST script tag and insert before its close
                # Or just append a new script tag before </body>
                $c = $c -replace '(</body>)', "`n  <script>`n$responsiveJs`n  </script>`n$1"
            }
            else {
                $c = $c -replace '(</body>)', "`n  <script>`n$responsiveJs`n  </script>`n$1"
            }
        }

        # 5. Clean up old media queries that might conflict
        $c = $c -replace '(?s)@media\s*\(max-width:\s*1100px\)\s*\{.*?\}', ''

        Set-Content $file.FullName -Value $c -Encoding UTF8
        Write-Host "Optimized: $($file.Name)"
    }
    catch {
        Write-Error "Failed to optimize $($file.Name): $_"
    }
}
Write-Host "✅ 100% Mobile & Device Optimization Complete."
