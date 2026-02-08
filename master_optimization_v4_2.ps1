# GAME DEBATE - LUXURY RESPONSIVE SYSTEM (v4.2 - ASCII ONLY SCRIPT)

# Define Georgian strings using decimal char codes (ASCII safe)
# მ=4315, თ=4311, ა=4304, ვ=4309, რ=4320, ი=4312
$s_home = [string][char[]]@(4315, 4311, 4304, 4309, 4304, 4320, 4312)
# ს=4321, ი=4312, ა=4304, ხ=4334, ლ=4314, ე=4308, ბ=4305, ი=4312
$s_news = [string][char[]]@(4321, 4312, 4304, 4334, 4314, 4308, 4308, 4305, 4312)
# თ=4311, ა=4304, მ=4315, ა=4304, შ=4328, ე=4308, ბ=4305, ი=4312
$s_games = [string][char[]]@(4311, 4304, 4315, 4304, 4328, 4308, 4305, 4312)
# ა=4304, პ=4314, ა=4304, რ=4320, ა=4304, ტ=4322, უ=4323, რ=4320, ა=4304
$s_hardware = [string][char[]]@(4304, 4318, 4304, 4320, 4304, 4322, 4323, 4320, 4304)
# მ=4315, ი=4312, მ=4315, ო=4317, ხ=4334, ი=4312, ლ=4314, ვ=4309, ა=4304
$s_reviews = [string][char[]]@(4315, 4312, 4315, 4317, 4334, 4312, 4314, 4309, 4304)
# ჯ=4335, ი=4312, ლ=4314, დ=4307, ო=4317, ე=4308, ბ=4305, ი=4312
$s_awards = [string][char[]]@(4335, 4312, 4314, 4307, 4317, 4308, 4305, 4312)
# გ=4306, ა=4304, ვ=4309, ქ=4325, ა=4304, ჩ=4329, ა=4304, ვ=4309
$s_runit = [string][char[]]@(4306, 4304, 4309, 4325, 4304, 4329, 4304, 4309) + "?"

$css = @"
/* LUXURY SCALING SYSTEM v4.2 */
:root { 
    --max-content-width: clamp(1200px, 95vw, 2200px); 
    --side-gap: clamp(15px, 5vw, 100px); 
}
* { box-sizing: border-box; }
body { overflow-x: hidden; width: 100vw; background: #050208; }
.frame { width: 100% !important; max-width: var(--max-content-width) !important; margin: 0 auto !important; padding: 0 !important; }

.topbar { 
    width: clamp(92%, 96%, 98%) !important; 
    max-width: 1900px !important; 
    margin: clamp(10px, 2vh, 40px) auto !important; 
    padding: clamp(8px, 1.4vh, 22px) clamp(15px, 4vw, 60px) !important; 
    border-radius: 100px !important; 
    top: clamp(10px, 1.5vh, 30px) !important; 
    display: flex !important; 
    justify-content: space-between !important; 
    align-items: center !important;
    background: rgba(15, 10, 25, 0.85) !important;
    backdrop-filter: blur(30px) saturate(180%) !important;
    border: 1px solid rgba(255, 255, 255, 0.12) !important;
    box-shadow: 0 25px 50px rgba(0,0,0,0.6) !important;
    z-index: 1000 !important;
    transition: all 0.5s ease-out !important;
}

.hero-container { padding: clamp(20px, 5vh, 60px) var(--side-gap) !important; }
.slider-wrapper { height: clamp(350px, 62vh, 850px) !important; border-radius: 40px !important; }
.slide-title { font-size: clamp(26px, 6.5vw, 92px) !important; font-weight: 700 !important; }

.content-grid { 
    display: grid !important; 
    grid-template-columns: 1fr 400px !important; 
    gap: clamp(30px, 5vw, 80px) !important; 
    padding: 20px var(--side-gap) 100px !important; 
}

@media (max-width: 1200px) { 
    .content-grid { grid-template-columns: 1fr !important; } 
    .nav { display: none !important; } 
    .mobile-toggle { display: flex !important; } 
}

@media (max-width: 600px) {
    .topbar { width: 95% !important; border-radius: 30px !important; padding: 10px 20px !important; }
    .auth { display: none !important; }
}

.mobile-toggle { 
    display: none; width: 48px; height: 48px; flex-direction: column; justify-content: center; align-items: center; gap: 6px; cursor: pointer; z-index: 30000 !important; 
    background: rgba(138, 77, 255, 0.15); border: 1px solid rgba(138, 77, 255, 0.4); border-radius: 50%;
}
.mobile-toggle span { width: 22px; height: 2px; background: #fff; border-radius: 2px; transition: 0.3s; }
.mobile-toggle.active span:nth-child(1) { transform: translateY(8px) rotate(45deg); }
.mobile-toggle.active span:nth-child(2) { opacity: 0; }
.mobile-toggle.active span:nth-child(3) { transform: translateY(-8px) rotate(-45deg); }

.mobile-menu { 
    position: fixed; inset: 0; background: radial-gradient(circle at center, rgba(20, 10, 40, 0.98), rgba(5, 5, 10, 1)); backdrop-filter: blur(50px); z-index: 25000 !important; 
    display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 20px; opacity: 0; visibility: hidden; transition: all 0.5s ease;
}
.mobile-menu.active { opacity: 1; visibility: visible; }
.mobile-menu a { font-family: "Oswald"; font-size: clamp(26px, 10vw, 52px); color: #fff; text-decoration: none; text-transform: uppercase; letter-spacing: 4px; transition: 0.3s; }
.mobile-menu a:hover { color: var(--accent); transform: scale(1.1); }

.menu-close-btn { 
    position: absolute; top: 40px; right: 40px; width: 64px; height: 64px; background: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 50%; 
    display: flex; align-items: center; justify-content: center; color: #fff; font-size: 40px; cursor: pointer; z-index: 30001; transition: 0.3s;
}
.menu-close-btn:hover { background: #ff4757; transform: rotate(90deg); }
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
        m.onclick = (e) => { if (e.target === m) { m.classList.remove('active'); t.classList.remove('active'); document.body.style.overflow = ''; } };
      }
    })();
"@

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    # Read with UTF8 NO BOM
    $c = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # 1. CLEANUP PREVIOUS VERSIONS
    $c = [regex]::Replace($c, '(?s)/\* 🚀 GLOBAL DESIGN SCALING SYSTEM .*?\*/.*?}', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)/\* LUXURY SCALING SYSTEM .*?\*/.*?}', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
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
}
Write-Host "Done v4.2"
