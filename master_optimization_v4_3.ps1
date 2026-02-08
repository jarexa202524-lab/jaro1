# GAME DEBATE - LUXURY RESPONSIVE SYSTEM (v4.3 - FINAL REFINEMENT)

# RE-DEFINE STRINGS WITHOUT SPACES
$s_home = [char[]]@(4315, 4311, 4304, 4309, 4304, 4320, 4312) -join ''
$s_news = [char[]]@(4321, 4312, 4304, 4334, 4314, 4308, 4308, 4305, 4312) -join ''
$s_games = [char[]]@(4311, 4304, 4315, 4304, 4328, 4308, 4305, 4312) -join ''
$s_hardware = [char[]]@(4304, 4318, 4304, 4320, 4304, 4322, 4323, 4320, 4304) -join ''
$s_reviews = [char[]]@(4315, 4312, 4315, 4317, 4334, 4312, 4314, 4309, 4304) -join ''
$s_awards = [char[]]@(4335, 4312, 4314, 4307, 4317, 4308, 4305, 4312) -join ''
$s_runit = ([char[]]@(4306, 4304, 4309, 4325, 4304, 4329, 4304, 4309) -join '') + "?"

$css = @"
/* LUXURY SCALING SYSTEM v4.3 */
:root { 
    --max-content-width: clamp(1200px, 95vw, 2400px); 
    --side-gap: clamp(15px, 5vw, 120px); 
}
* { box-sizing: border-box; }
body { overflow-x: hidden; width: 100vw; background: #050208; }
.frame { width: 100% !important; max-width: var(--max-content-width) !important; margin: 0 auto !important; padding: 0 !important; }

/* TOPBAR - MASTER SCALING */
.topbar { 
    width: clamp(92%, 96%, 98%) !important; 
    max-width: 2000px !important; 
    margin: clamp(10px, 2.5vh, 45px) auto !important; 
    padding: clamp(8px, 1.4vh, 24px) clamp(15px, 4vw, 70px) !important; 
    border-radius: 100px !important; 
    top: clamp(10px, 2vh, 40px) !important; 
    display: flex !important; 
    justify-content: space-between !important; 
    align-items: center !important;
    background: rgba(18, 12, 30, 0.85) !important;
    backdrop-filter: blur(35px) saturate(180%) !important;
    border: 1px solid rgba(255, 255, 255, 0.12) !important;
    box-shadow: 0 30px 60px rgba(0,0,0,0.65) !important;
    z-index: 1000 !important;
}

.hero-container { padding: clamp(20px, 5vh, 60px) var(--side-gap) !important; }
.slider-wrapper { height: clamp(350px, 60vh, 900px) !important; border-radius: 40px !important; }
.slide-title { font-size: clamp(26px, 6vw, 96px) !important; }

.content-grid { 
    display: grid !important; 
    grid-template-columns: 1fr 420px !important; 
    gap: clamp(30px, 5vw, 100px) !important; 
    padding: 20px var(--side-gap) 100px !important; 
}

@media (max-width: 1250px) { 
    .content-grid { grid-template-columns: 1fr !important; } 
    .nav { display: none !important; } 
    .mobile-toggle { display: flex !important; } 
}

@media (max-width: 600px) {
    .topbar { width: 96% !important; border-radius: 35px !important; padding: 10px 20px !important; }
    .auth { display: none !important; }
    #userBadge { display: flex !important; } #userBadge span { display: none; }
}

.mobile-toggle { 
    display: none; width: 52px; height: 52px; flex-direction: column; justify-content: center; align-items: center; gap: 6px; cursor: pointer; z-index: 30000 !important; 
    background: rgba(138, 77, 255, 0.15); border: 1px solid rgba(138, 77, 255, 0.4); border-radius: 50%;
}
.mobile-toggle span { width: 24px; height: 2px; background: #fff; border-radius: 2px; transition: 0.3s; }
.mobile-toggle.active span:nth-child(1) { transform: translateY(8px) rotate(45deg); }
.mobile-toggle.active span:nth-child(2) { opacity: 0; }
.mobile-toggle.active span:nth-child(3) { transform: translateY(-8px) rotate(-45deg); }

.mobile-menu { 
    position: fixed; inset: 0; background: radial-gradient(circle at center, rgba(30, 15, 60, 0.99), rgba(5, 5, 12, 1)); backdrop-filter: blur(60px); z-index: 28000 !important; 
    display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 25px; opacity: 0; visibility: hidden; transition: all 0.5s cubic-bezier(0.19, 1, 0.22, 1);
}
.mobile-menu.active { opacity: 1; visibility: visible; }
.mobile-menu a { font-family: "Oswald"; font-size: clamp(28px, 12vw, 56px); color: #fff; text-decoration: none; text-transform: uppercase; letter-spacing: 5px; transition: 0.4s; }
.mobile-menu a:hover { color: var(--accent); transform: scale(1.1); text-shadow: 0 0 30px var(--accent-glow); }

.menu-close-btn { 
    position: absolute; top: 40px; right: 40px; width: 64px; height: 64px; background: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 50%; 
    display: flex; align-items: center; justify-content: center; color: #fff; font-size: 44px; cursor: pointer; z-index: 30001 !important; transition: 0.4s;
}
.menu-close-btn:hover { background: #ff4757; transform: rotate(90deg); box-shadow: 0 0 30px rgba(255, 71, 87, 0.4); }
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
    <div id="mobileAuthContainer" style="margin-top: 50px; display: flex; gap: 20px;"></div>
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
        const toggleMenu = (open) => {
          m.classList[open ? 'add' : 'remove']('active');
          t.classList[open ? 'add' : 'remove']('active');
          document.body.style.overflow = open ? 'hidden' : '';
          if (open && ac && da && ac.children.length === 0) ac.innerHTML = da.innerHTML;
        };
        t.onclick = (e) => { e.stopPropagation(); toggleMenu(!m.classList.contains('active')); };
        if (c) c.onclick = (e) => { e.stopPropagation(); toggleMenu(false); };
        m.onclick = (e) => { if (e.target === m) toggleMenu(false); };
        m.querySelectorAll('a').forEach(l => l.onclick = () => toggleMenu(false));
      }
    })();
"@

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    # Read with UTF8 NO BOM
    $c = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # --- RIGOROUS CLEANUP ---
    $c = [regex]::Replace($c, '(?s)/\* 🚀 GLOBAL DESIGN .*?\*/.*?}', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)/\* LUXURY SCALING SYSTEM .*?\*/.*?}', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)/\* 📱 PROJECT-WIDE RESPONSIVE .*?\*/.*?</style>', '</style>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)<!-- MOBILE MENU -->.*?</div>\s+</div>\s+</div>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)<div class="mobile-menu".*?</div>\s+</div>\s+</div>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)<div class="mobile-menu".*?</div>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)</div>\s+</div>\s+<div id="modern-background">', '<div id="modern-background">', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)<div class="mobile-toggle".*?</div>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)<script>\s*\(function\(\)\s*\{.*?\}\)\(\);?\s*</script>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)<!-- MOBILE MENU -->.*?</div>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # --- INJECT NEW ---
    if ($c -match '</style>') { $c = $c.Replace('</style>', "$css`n</style>") }
    if ($c -match '<body.*?>') { $c = [regex]::Replace($c, '(<body.*?>)', "`$1`n$menuHtml") }
    if ($c -match '</header>') { $c = $c.Replace('</header>', "$toggleHtml`n</header>") }
    if ($c -match '</body>') { $c = $c.Replace('</body>', "<script>$js</script></body>") }
    
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($file.FullName, $c, $utf8NoBom)
}
Write-Host "Done v4.3"
