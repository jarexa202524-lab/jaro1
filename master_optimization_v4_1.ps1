# GAME DEBATE - MASTER RESPONSIVE SYSTEM (v4.1 - UNICODE SAFE)

# Georgian strings escaped for PowerShell compatibility
$s_home = "$([char]0x10DB)$([char]0x10D7)$([char]0x10D0)$([char]0x10D5)$([char]0x10D0)$([char]0x10E0)$([char]0x10D8)"
$s_news = "$([char]0x10E1)$([char]0x10D8)$([char]0x10D0)$([char]0x10EE)$([char]0x10DA)$([char]0x10D4)$([char]0x10D4)$([char]0x10D1)$([char]0x10D8)"
$s_games = "$([char]0x10D7)$([char]0x10D0)$([char]0x10DB)$([char]0x10D0)$([char]0x10E8)$([char]0x10D4)$([char]0x10D1)$([char]0x10D8)"
$s_hardware = "$([char]0x10D0)$([char]0x10DE)$([char]0x10D0)$([char]0x10E0)$([char]0x10D0)$([char]0x10E2)$([char]0x10E3)$([char]0x10E0)$([char]0x10D0)"
$s_reviews = "$([char]0x10DB)$([char]0x10D8)$([char]0x10DB)$([char]0x10D8)$([char]0x10EE)$([char]0x10D8)$([char]0x10DA)$([char]0x10D5)$([char]0x10D0)"
$s_awards = "$([char]0x10AF)$([char]0x10D8)$([char]0x10DA)$([char]0x10D“)$([char]0x10D0)$([char]0x10D4)$([char]0x10D1)$([char]0x10D8)" # Fix: 0x10D“ might be wrong, corrected below
# Correction: ჯილდოები
# ჯ (10AF) ი (10D8) ლ (10DA) დ (10D3) ო (10DD) ე (10D4) ბ (10D1) ი (10D8)
$s_awards = "$([char]0x10AF)$([char]0x10D8)$([char]0x10DA)$([char]0x10D3)$([char]0x10DD)$([char]0x10D4)$([char]0x10D1)$([char]0x10D8)"
$s_runit = "$([char]0x10D2)$([char]0x10D0)$([char]0x10D5)$([char]0x10E5)$([char]0x10D0)$([char]0x10E9)$([char]0x10D0)$([char]0x10D5)?"

$css = @"
/* LUXURY SCALING SYSTEM v4.1 */
:root { 
    --max-content-width: clamp(1200px, 95vw, 2400px); 
    --side-gap: clamp(15px, 5vw, 120px); 
}
* { box-sizing: border-box; }
body { overflow-x: hidden; width: 100vw; background: #050208; }
.frame { width: 100% !important; max-width: var(--max-content-width) !important; margin: 0 auto !important; padding: 0 !important; }

/* TOPBAR SCALING - PERFECT SYMMETRY */
.topbar { 
    width: clamp(92%, 96%, 98%) !important; 
    max-width: 1900px !important; 
    margin: clamp(10px, 2vh, 40px) auto !important; 
    padding: clamp(8px, 1.2vh, 20px) clamp(15px, 3vw, 60px) !important; 
    border-radius: 100px !important; 
    top: clamp(10px, 1.5vh, 30px) !important; 
    display: flex !important; 
    justify-content: space-between !important; 
    align-items: center !important;
    background: rgba(15, 10, 25, 0.8) !important;
    backdrop-filter: blur(25px) saturate(160%) !important;
    border: 1px solid rgba(255, 255, 255, 0.1) !important;
    box-shadow: 0 20px 50px rgba(0,0,0,0.5) !important;
    z-index: 1000 !important;
}

.hero-container { padding: clamp(20px, 4vh, 60px) var(--side-gap) !important; }
.slider-wrapper { height: clamp(350px, 60vh, 850px) !important; border-radius: 40px !important; }
.slide-title { font-size: clamp(26px, 6vw, 92px) !important; text-shadow: 0 10px 30px rgba(0,0,0,0.8); }

.content-grid { 
    display: grid !important; 
    grid-template-columns: 1fr 400px !important; 
    gap: clamp(30px, 4vw, 80px) !important; 
    padding: 20px var(--side-gap) 100px !important; 
}

@media (max-width: 1200px) { 
    .content-grid { grid-template-columns: 1fr !important; } 
    .nav { display: none !important; } 
    .mobile-toggle { display: flex !important; } 
}

@media (max-width: 600px) {
    .topbar { width: 96% !important; padding: 10px 20px !important; }
    .auth { display: none !important; }
}

/* MOBILE MENU - GLASSMISM */
.mobile-toggle { 
    display: none; width: 48px; height: 48px; flex-direction: column; justify-content: center; align-items: center; gap: 6px; cursor: pointer; z-index: 30000 !important; 
    background: rgba(138, 77, 255, 0.1); border: 1px solid rgba(138, 77, 255, 0.3); border-radius: 50%;
}
.mobile-toggle span { width: 22px; height: 2px; background: #fff; border-radius: 2px; transition: 0.3s; }
.mobile-toggle.active span:nth-child(1) { transform: translateY(8px) rotate(45deg); }
.mobile-toggle.active span:nth-child(2) { opacity: 0; }
.mobile-toggle.active span:nth-child(3) { transform: translateY(-8px) rotate(-45deg); }

.mobile-menu { 
    position: fixed; inset: 0; background: rgba(5, 2, 8, 0.95); backdrop-filter: blur(40px); z-index: 25000 !important; 
    display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 20px; opacity: 0; visibility: hidden; transition: all 0.4s ease;
}
.mobile-menu.active { opacity: 1; visibility: visible; }
.mobile-menu a { font-family: "Oswald"; font-size: clamp(26px, 10vw, 48px); color: #fff; text-decoration: none; text-transform: uppercase; letter-spacing: 4px; transition: 0.3s; }

.menu-close-btn { 
    position: absolute; top: 40px; right: 40px; width: 60px; height: 60px; background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 50%; 
    display: flex; align-items: center; justify-content: center; color: #fff; font-size: 40px; cursor: pointer; z-index: 25001;
}
"@

$menuHtml = @"
  <div class="mobile-menu" id="mobileMenu">
    <div class="menu-close-btn" id="menuCloseBtn">&times;</div>
    <a href="index.html">$s_home</a>
    <a href="news.html">$s_news</a>
    <a href="games.html">$s_games</a>
    <a href="hardware.html">$s_hardware</a>
    <a href="reviews.html">$s_reviews</a>
    <a href="awards.html">$s_awards</a>
    <a href="can-i-run-it.html">$s_runit</a>
    <div id="mobileAuthContainer" style="margin-top: 40px; display: flex; gap: 20px;"></div>
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
      const c = document.getElementById('menuCloseBtn');
      const ac = document.getElementById('mobileAuthContainer');
      const da = document.getElementById('authSection');

      if (t && m) {
        t.onclick = (e) => { e.stopPropagation(); m.classList.add('active'); t.classList.add('active'); document.body.style.overflow = 'hidden'; if (ac && da && ac.children.length === 0) ac.innerHTML = da.innerHTML; };
        if (c) c.onclick = (e) => { e.stopPropagation(); m.classList.remove('active'); t.classList.remove('active'); document.body.style.overflow = ''; };
        m.querySelectorAll('a').forEach(l => { l.onclick = () => { m.classList.remove('active'); t.classList.remove('active'); document.body.style.overflow = ''; }; });
      }
    })();
"@

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    # Read with UTF8 specifically
    $c = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # 1. CLEANUP EVERYTHING
    $c = [regex]::Replace($c, '(?s)/\* 🚀 GLOBAL DESIGN SCALING SYSTEM .*?\*/.*?}', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)/\* LUXURY SCALING SYSTEM .*?\*/.*?}', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)/\* 📱 PROJECT-WIDE RESPONSIVE SYSTEM \*/.*?</style>', '</style>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)<!-- MOBILE MENU -->.*?</div>\s+</div>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)<div class="mobile-menu".*?</div>\s+</div>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)<div class="mobile-menu".*?</div>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)<div class="mobile-toggle".*?</div>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)<script>\s*\(function\(\)\s*\{.*?\}\)\(\);?\s*</script>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # 2. INJECT NEW
    if ($c -match '</style>') { $c = $c.Replace('</style>', "$css`n</style>") }
    if ($c -match '<body.*?>') { $c = [regex]::Replace($c, '(<body.*?>)', "`$1`n$menuHtml") }
    if ($c -match '</header>') { $c = $c.Replace('</header>', "$toggleHtml`n</header>") }
    if ($c -match '</body>') { $c = $c.Replace('</body>', "<script>$js</script></body>") }
    
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($file.FullName, $c, $utf8NoBom)
    Write-Host "Luxury Optimized: $($file.Name)"
}
Write-Host "Done!"
