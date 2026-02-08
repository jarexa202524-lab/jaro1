# GAME DEBATE - MASTER RESPONSIVE SYSTEM (POWER-OPT v3.0)

$css = @"
/* 🚀 GLOBAL DESIGN SCALING SYSTEM */
:root { --max-content-width: 1800px; --side-gap: clamp(20px, 6vw, 80px); }
* { box-sizing: border-box; }
body { overflow-x: hidden; width: 100vw; }
.frame { width: 100% !important; max-width: var(--max-content-width) !important; margin: 0 auto !important; padding: 0 !important; }
.topbar { width: 95% !important; max-width: 1600px !important; margin: 20px auto !important; padding: 10px 40px !important; border-radius: 60px !important; top: 20px !important; display: flex !important; justify-content: space-between !important; align-items: center !important; }
.hero-container { padding: 30px var(--side-gap) !important; }
.slider-wrapper { height: clamp(350px, 55vh, 750px) !important; border-radius: 40px !important; }
.slide-title { font-size: clamp(28px, 5vw, 72px) !important; }
.content-grid { display: grid !important; grid-template-columns: 1fr 380px !important; gap: 50px !important; padding: 0 var(--side-gap) 100px !important; max-width: 100% !important; }

/* BREAKPOINTS */
@media (min-width: 2000px) { :root { --max-content-width: 2200px; } .slide-title { font-size: 84px !important; } }
@media (max-width: 1100px) { .content-grid { grid-template-columns: 1fr !important; } .nav { display: none !important; } .mobile-toggle { display: flex !important; } }
@media (max-width: 600px) {
  .topbar { width: 98% !important; top: 10px !important; padding: 8px 15px !important; }
  .auth { display: none !important; }
  .user-badge span { display: none !important; }
  .slider-wrapper { height: 350px !important; }
  .content-grid { padding: 0 15px 60px !important; }
}

/* MOBILE MENU & FIXES */
.mobile-toggle { display: none; width: 45px; height: 45px; flex-direction: column; justify-content: center; align-items: center; gap: 6px; cursor: pointer; z-index: 20000 !important; background: rgba(138, 77, 255, 0.15); border: 1px solid var(--accent); border-radius: 12px; margin-left:15px; }
.mobile-toggle span { width: 22px; height: 2px; background: #fff; border-radius: 2px; transition: 0.3s; }
.mobile-toggle.active span:nth-child(1) { transform: translateY(8px) rotate(45deg); }
.mobile-toggle.active span:nth-child(2) { opacity: 0; }
.mobile-toggle.active span:nth-child(3) { transform: translateY(-8px) rotate(-45deg); }
.mobile-menu { position: fixed; inset: 0; background: rgba(5, 2, 8, 0.99); backdrop-filter: blur(30px); z-index: 10000 !important; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 25px; opacity: 0; visibility: hidden; transition: all 0.4s ease; }
.mobile-menu.active { opacity: 1; visibility: visible; }
.mobile-menu a { font-family: "Oswald"; font-size: 32px; color: #fff; text-decoration: none; text-transform: uppercase; letter-spacing: 2px; }
"@

$menuHtml = @"
  <div class="mobile-menu" id="mobileMenu">
    <a href="index.html">მთავარი</a>
    <a href="news.html">სიახლეები</a>
    <a href="games.html">თამაშები</a>
    <a href="hardware.html">აპარატურა</a>
    <a href="reviews.html">მიმოხილვა</a>
    <a href="awards.html">ჯილდოები</a>
    <a href="can-i-run-it.html">გავქაჩავ?</a>
    <div id="mobileAuthContainer" style="margin-top: 40px; display: flex; gap: 15px;"></div>
  </div>
"@

$toggleHtml = @"
    <div class="mobile-toggle" id="mobileToggle">
      <span></span><span></span><span></span>
    </div>
"@

$js = @"
    (function() {
      const t = document.getElementById('mobileToggle');
      const m = document.getElementById('mobileMenu');
      const ac = document.getElementById('mobileAuthContainer');
      const da = document.getElementById('authSection');
      if (t && m) {
        t.onclick = (e) => {
          e.stopPropagation();
          const isActive = m.classList.toggle('active');
          t.classList.toggle('active');
          document.body.style.overflow = isActive ? 'hidden' : '';
          if (isActive && ac && da && ac.children.length === 0) ac.innerHTML = da.innerHTML;
        };
        m.querySelectorAll('a').forEach(l => {
          l.onclick = () => { t.classList.remove('active'); m.classList.remove('active'); document.body.style.overflow = ''; };
        });
      }
    })();
"@

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    # Read with UTF8 NO BOM
    $c = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # CLEAN OLD VERSION FIRST TO PREVENT DUPLICATES
    $c = [regex]::Replace($c, '(?s)/\* 📱 PROJECT-WIDE RESPONSIVE SYSTEM \*/.*?</style>', '</style>')
    $c = [regex]::Replace($c, '(?s)<div class="mobile-menu".*?</div>', '')
    $c = [regex]::Replace($c, '(?s)<div class="mobile-toggle".*?</div>', '')
    $c = [regex]::Replace($c, '(?s)<script>\s*\(function\(\)\s*\{.*?\}\)\(\);?\s*</script>', '')

    # INJECT NEW
    if ($c -match '</style>') { $c = $c.Replace('</style>', "$css`n</style>") }
    if ($c -match '<body.*?>') { $c = [regex]::Replace($c, '(<body.*?>)', "`$1`n$menuHtml") }
    if ($c -match '</header>') { $c = $c.Replace('</header>', "$toggleHtml`n</header>") }
    if ($c -match '</body>') { $c = $c.Replace('</body>', "<script>$js</script></body>") }
    
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($file.FullName, $c, $utf8NoBom)
    Write-Host "Master Optimized: $($file.Name)"
}
