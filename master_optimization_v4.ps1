# GAME DEBATE - MASTER RESPONSIVE SYSTEM (POWER-OPT v4.0 - ULTRA STRICT UTF8)

# Define strings with Georgian text explicitly
$menuGeorgian = @{
    Home     = "მთავარი"
    News     = "სიახლეები"
    Games    = "თამაშები"
    Hardware = "აპარატურა"
    Reviews  = "მიმოხილვა"
    Awards   = "ჯილდოები"
    RunIt    = "გავქაჩავ?"
    Close    = "დახურვა"
}

$css = @"
/* 🚀 GLOBAL DESIGN SCALING SYSTEM v4.0 */
:root { 
    --max-content-width: clamp(1200px, 95vw, 2200px); 
    --side-gap: clamp(15px, 5vw, 100px); 
    --topbar-top: clamp(10px, 2vh, 30px);
}

* { box-sizing: border-box; }
body { overflow-x: hidden; width: 100vw; }

.frame { 
    width: 100% !important; 
    max-width: var(--max-content-width) !important; 
    margin: 0 auto !important; 
    padding: 0 !important; 
}

/* TOPBAR SCALING - IDENTICAL ON ALL DEVICES */
.topbar { 
    width: clamp(90%, 95%, 98%) !important; 
    max-width: 1800px !important; 
    margin: var(--topbar-top) auto !important; 
    padding: clamp(6px, 1.2vh, 18px) clamp(10px, 3vw, 50px) !important; 
    border-radius: clamp(30px, 5vw, 80px) !important; 
    top: var(--topbar-top) !important; 
    display: flex !important; 
    justify-content: space-between !important; 
    align-items: center !important;
    transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

.hero-container { padding: clamp(20px, 4vh, 50px) var(--side-gap) !important; }
.slider-wrapper { height: clamp(300px, 55vh, 800px) !important; border-radius: clamp(20px, 4vw, 50px) !important; }
.slide-title { font-size: clamp(22px, 5.5vw, 86px) !important; }

.content-grid { 
    display: grid !important; 
    grid-template-columns: 1fr 380px !important; 
    gap: clamp(20px, 4vw, 60px) !important; 
    padding: 0 var(--side-gap) 100px !important; 
}

/* BREAKPOINTS */
@media (max-width: 1150px) { 
    .content-grid { grid-template-columns: 1fr !important; } 
    .nav { display: none !important; } 
    .mobile-toggle { display: flex !important; } 
}

@media (max-width: 600px) {
    .auth { display: none !important; }
    .user-badge { padding: 4px !important; }
    .user-badge span { display: none !important; }
}

/* MOBILE MENU - PREMIUM ENHANCED */
.mobile-toggle { 
    display: none; 
    width: 48px; 
    height: 48px; 
    flex-direction: column; 
    justify-content: center; 
    align-items: center; 
    gap: 6px; 
    cursor: pointer; 
    z-index: 30000 !important; 
    background: rgba(138, 77, 255, 0.2); 
    border: 1px solid var(--accent); 
    border-radius: 14px; 
    margin-left: 10px;
}
.mobile-toggle span { width: 24px; height: 2px; background: #fff; border-radius: 2px; transition: 0.4s; }
.mobile-toggle.active span:nth-child(1) { transform: translateY(8px) rotate(45deg); }
.mobile-toggle.active span:nth-child(2) { opacity: 0; }
.mobile-toggle.active span:nth-child(3) { transform: translateY(-8px) rotate(-45deg); }

.mobile-menu { 
    position: fixed; 
    inset: 0; 
    background: radial-gradient(circle at center, rgba(30, 10, 60, 0.98), rgba(5, 2, 10, 0.99)); 
    backdrop-filter: blur(40px) saturate(150%); 
    z-index: 25000 !important; 
    display: flex; 
    flex-direction: column; 
    align-items: center; 
    justify-content: center; 
    gap: 20px; 
    opacity: 0; 
    visibility: hidden; 
    transition: all 0.5s cubic-bezier(0.16, 1, 0.3, 1);
}
.mobile-menu.active { opacity: 1; visibility: visible; }
.mobile-menu a { 
    font-family: "Oswald"; 
    font-size: clamp(24px, 8vw, 44px); 
    color: #fff; 
    text-decoration: none; 
    text-transform: uppercase; 
    letter-spacing: 4px;
    transition: 0.3s;
    opacity: 0;
    transform: translateY(20px);
}
.mobile-menu.active a { opacity: 1; transform: translateY(0); }
.mobile-menu a:hover { color: var(--accent); transform: scale(1.1); text-shadow: 0 0 20px var(--accent-glow); }

/* CLOSE BUTTON INSIDE MENU */
.menu-close-btn {
    position: absolute;
    top: 40px;
    right: 40px;
    width: 60px;
    height: 60px;
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    font-size: 30px;
    cursor: pointer;
    transition: 0.3s;
}
.menu-close-btn:hover { background: var(--accent); border-color: var(--accent); transform: rotate(90deg); }
"@

$menuHtml = @"
  <div class="mobile-menu" id="mobileMenu">
    <div class="menu-close-btn" id="menuCloseBtn">&times;</div>
    <a href="index.html" style="transition-delay: 0.1s">$($menuGeorgian.Home)</a>
    <a href="news.html" style="transition-delay: 0.2s">$($menuGeorgian.News)</a>
    <a href="games.html" style="transition-delay: 0.3s">$($menuGeorgian.Games)</a>
    <a href="hardware.html" style="transition-delay: 0.4s">$($menuGeorgian.Hardware)</a>
    <a href="reviews.html" style="transition-delay: 0.5s">$($menuGeorgian.Reviews)</a>
    <a href="awards.html" style="transition-delay: 0.6s">$($menuGeorgian.Awards)</a>
    <a href="can-i-run-it.html" style="transition-delay: 0.7s">$($menuGeorgian.RunIt)</a>
    <div id="mobileAuthContainer" style="margin-top: 40px; display: flex; gap: 20px; opacity:0; transform:translateY(20px); transition:all 0.5s 0.8s;"></div>
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
      
      function openMenu() {
        m.classList.add('active');
        t.classList.add('active');
        document.body.style.overflow = 'hidden';
        if (ac && da && ac.children.length === 0) {
            ac.innerHTML = da.innerHTML;
            ac.style.opacity = '1';
            ac.style.transform = 'translateY(0)';
        }
      }

      function closeMenu() {
        m.classList.remove('active');
        t.classList.remove('active');
        document.body.style.overflow = '';
      }

      if (t && m) {
        t.onclick = (e) => {
          e.stopPropagation();
          if (m.classList.contains('active')) closeMenu();
          else openMenu();
        };
        if (c) c.onclick = (e) => { e.stopPropagation(); closeMenu(); };
        
        m.querySelectorAll('a').forEach(l => {
          l.onclick = () => closeMenu();
        });
        
        // Safety: Close on backdrop click if needed
        m.onclick = (e) => { if (e.target === m) closeMenu(); };
      }
    })();
"@

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    # READ WITH SPECIFIC UTF8 ENCODING
    $c = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # 1. CLEANUP (More aggressive cleanup of all previous versions)
    $c = [regex]::Replace($c, '(?s)/\* 🚀 GLOBAL DESIGN SCALING SYSTEM .*?\*/.*?}', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)/\* 📱 PROJECT-WIDE RESPONSIVE SYSTEM \*/.*?</style>', '</style>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)<!-- MOBILE MENU -->.*?</div>\s+</div>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)<div class="mobile-menu".*?</div>\s+</div>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase) # Handle nested divs
    $c = [regex]::Replace($c, '(?s)<div class="mobile-menu".*?</div>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)<div class="mobile-toggle".*?</div>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $c = [regex]::Replace($c, '(?s)<script>\s*\(function\(\)\s*\{.*?\}\)\(\);?\s*</script>', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # 2. INJECT NEW CSS
    if ($c -match '</style>') { $c = $c.Replace('</style>', "$css`n</style>") }
    
    # 3. INJECT NEW MENU HTML
    if ($c -match '<body.*?>') { $c = [regex]::Replace($c, '(<body.*?>)', "`$1`n$menuHtml") }
    
    # 4. INJECT NEW TOGGLE
    if ($c -match '</header>') { $c = $c.Replace('</header>', "$toggleHtml`n</header>") }
    
    # 5. INJECT NEW JS
    if ($c -match '</body>') { $c = $c.Replace('</body>', "<script>$js</script></body>") }
    
    # 6. ENCODING REPAIR
    # Sometimes PowerShell strings mess up during Replace. We force a re-encoding check.
    
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($file.FullName, $c, $utf8NoBom)
    Write-Host "Ultra Optimized (v4.0): $($file.Name)"
}
Write-Host "✅ Global Premium Responsive System Implemented."
