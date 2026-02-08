# GAME DEBATE - SURGICAL RESPONSIVE OPTIMIZER

$responsiveCss = Get-Content "responsive_v2.css" -Raw

$mobileMenuHtml = @"
  <!-- MOBILE MENU -->
  <div class="mobile-menu" id="mobileMenu">
    <a href="index.html">მთავარი</a>
    <a href="news.html">სიახლეები</a>
    <a href="games.html">თამაშები</a>
    <a href="hardware.html">აპარატურა</a>
    <a href="reviews.html">მიმოხილვა</a>
    <a href="awards.html">ჯილდოები</a>
    <a href="can-i-run-it.html">გავქაჩავ?</a>
    <div id="mobileAuthContainer" style="margin-top: 30px; display: flex; gap: 15px;"></div>
  </div>
"@

$mobileToggleHtml = @"
      <div class="mobile-toggle" id="mobileToggle">
        <span></span>
        <span></span>
        <span></span>
      </div>
"@

$responsiveJs = @"
    // --- MOBILE MENU LOGIC ---
    (function() {
      const toggle = document.getElementById('mobileToggle');
      const menu = document.getElementById('mobileMenu');
      const authCont = document.getElementById('mobileAuthContainer');
      const desktopAuth = document.getElementById('authSection');

      if (toggle && menu) {
        toggle.addEventListener('click', () => {
          toggle.classList.toggle('active');
          menu.classList.toggle('active');
          document.body.style.overflow = menu.classList.contains('active') ? 'hidden' : '';
          
          if (authCont && desktopAuth && authCont.children.length === 0) {
            authCont.innerHTML = desktopAuth.innerHTML;
          }
        });

        // Close on link click
        menu.querySelectorAll('a').forEach(link => {
          link.addEventListener('click', () => {
            toggle.classList.remove('active');
            menu.classList.remove('active');
            document.body.style.overflow = '';
          });
        });
      }
    })();
"@

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    try {
        $c = Get-Content $file.FullName -Raw -Encoding UTF8
        
        # 1. Inject CSS before </style>
        if ($c -match '</style>') {
            $c = $c -replace '(?s)(</style>)', ($responsiveCss + "`n$1")
        }

        # 2. Inject Mobile Menu HTML right after <body>
        if ($c -match '<body.*?>') {
            $c = $c -replace '(<body.*?>)', "`$1`n$mobileMenuHtml"
        }

        # 3. Inject Toggle into Topbar (search for authSection container)
        if ($c -match 'id="authSection">') {
            $c = $c -replace '(id="authSection">.*?</div>)', "`$1`n$mobileToggleHtml"
        }

        # 4. Inject JS before </body>
        if ($c -match '</body>') {
            $c = $c -replace '(</body>)', "`n  <script>`n$responsiveJs`n  </script>`n$1"
        }

        Set-Content $file.FullName -Value $c -Encoding UTF8
        Write-Host "Surgical Optimization Applied: $($file.Name)"
    }
    catch {
        Write-Error "Failed $($file.Name): $_"
    }
}
Write-Host "✅ Global Responsive Optimization Complete."
