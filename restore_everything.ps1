# GAME DEBATE - UNIFIED LUXURY DESIGN SYSTEM v5.3
# Fixes orphaned links at the top of the body and ensures perfect layout.

# GEORGIAN STRINGS (ASCII SAFE)
$s_login = [char[]]@(4328, 4308, 4321, 4309, 4314, 4304) -join ''
$s_register = [char[]]@(4320, 4305, 4306, 4312, 4321, 4322, 4320, 4304, 4330, 4312, 4304) -join ''
$s_home = [char[]]@(4315, 4311, 4304, 4309, 4304, 4320, 4312) -join ''
$s_news = [char[]]@(4321, 4312, 4304, 4334, 4314, 4308, 4308, 4305, 4312) -join ''
$s_games = [char[]]@(4311, 4304, 4315, 4304, 4328, 4308, 4305, 4312) -join ''
$s_hardware = [char[]]@(4304, 4318, 4304, 4320, 4304, 4322, 4323, 4320, 4304) -join ''
$s_reviews = [char[]]@(4315, 4312, 4315, 4317, 4334, 4312, 4314, 4309, 4304) -join ''
$s_awards = [char[]]@(4335, 4312, 4314, 4307, 4317, 4308, 4305, 4312) -join ''
$s_runit = ([char[]]@(4306, 4304, 4309, 4325, 4304, 4329, 4304, 4309) -join '') + "?"

$modernStyles = @"
/* LUXURY SCALING SYSTEM v5.3 */
:root { 
    --max-content-width: clamp(1200px, 95vw, 2400px); 
    --side-gap: clamp(15px, 5vw, 120px); 
}
* { box-sizing: border-box; }
body { overflow-x: hidden; width: 100vw !important; background: #050208 !important; }

/* TOPBAR - MASTER OVAL */
.topbar { 
    width: clamp(92%, 96%, 98%) !important; 
    max-width: 2000px !important; 
    margin: clamp(10px, 2.5vh, 40px) auto !important; 
    padding: clamp(8px, 1.4vh, 22px) clamp(15px, 4vw, 70px) !important; 
    border-radius: 100px !important; 
    top: clamp(10px, 2vh, 40px) !important; 
    display: flex !important; 
    justify-content: space-between !important; 
    align-items: center !important;
    background: rgba(18, 12, 30, 0.85) !important;
    backdrop-filter: blur(35px) saturate(180%) !important;
    border: 1px solid rgba(255, 255, 255, 0.12) !important;
    box-shadow: 0 30px 60px rgba(0,0,0,0.65) !important;
    z-index: 10000 !important;
    transition: all 0.5s ease-out !important;
}

.nav a { transition: all 0.4s ease !important; }
.nav a:hover {
    color: #fff !important;
    background: rgba(138, 77, 255, 0.15) !important;
    transform: translateY(-2px) !important;
}
.nav a.active { background: transparent !important; box-shadow: none !important; color: var(--muted) !important; }

.mobile-toggle { 
    display: none; width: 44px; height: 44px; flex-direction: column; justify-content: center; align-items: center; gap: 5px; cursor: pointer;
    background: rgba(138, 77, 255, 0.1); border: 1px solid rgba(138, 77, 255, 0.3); border-radius: 50%;
}
.mobile-toggle span { width: 24px; height: 2px; background: #fff; border-radius: 2px; }

@media (max-width: 1250px) { .nav { display: none !important; } .mobile-toggle { display: flex !important; } }
"@

$headerHtml = @"
    <header class="topbar" id="mainTopbar">
      <a href="index.html" class="logo" style="text-decoration:none;">
        <span style="color:#fff; font-family:'Oswald'; font-size:22px; font-weight:700;"><b>GAME</b> DEBATE</span>
      </a>
      <nav class="nav">
        <a href="news.html">$s_news</a>
        <a href="games.html">$s_games</a>
        <a href="hardware.html">$s_hardware</a>
        <a href="reviews.html">$s_reviews</a>
        <a href="awards.html">$s_awards</a>
        <a href="can-i-run-it.html">$s_runit</a>
      </nav>
      <div class="auth" id="authSection">
        <a href="login.html" class="auth-btn login" style="color:#fff; text-decoration:none; font-weight:700; font-size:13px; padding:10px 20px;">$s_login</a>
        <a href="register.html" class="auth-btn register" style="background:var(--accent); color:#fff; text-decoration:none; font-weight:700; font-size:13px; padding:10px 25px; border-radius:30px; box-shadow:0 0 15px var(--accent-glow);">$s_register</a>
      </div>
      <div class="mobile-toggle" id="mobileToggle">
        <span></span><span></span><span></span>
      </div>
    </header>
"@

$menuHtml = @"
  <div class="mobile-menu" id="mobileMenu" style="position:fixed; inset:0; background:rgba(5,2,8,0.99); backdrop-filter:blur(50px); z-index:20000; display:flex; flex-direction:column; align-items:center; justify-content:center; gap:30px; opacity:0; visibility:hidden; transition:0.4s;">
    <div id="menuCloseBtn" style="position:absolute; top:30px; right:30px; font-size:40px; color:#fff; cursor:pointer;">&times;</div>
    <a href="index.html" style="font-family:'Oswald'; font-size:32px; color:#fff; text-decoration:none;">$s_home</a>
    <a href="news.html" style="font-family:'Oswald'; font-size:32px; color:#fff; text-decoration:none;">$s_news</a>
    <a href="games.html" style="font-family:'Oswald'; font-size:32px; color:#fff; text-decoration:none;">$s_games</a>
    <a href="hardware.html" style="font-family:'Oswald'; font-size:32px; color:#fff; text-decoration:none;">$s_hardware</a>
    <a href="reviews.html" style="font-family:'Oswald'; font-size:32px; color:#fff; text-decoration:none;">$s_reviews</a>
    <a href="awards.html" style="font-family:'Oswald'; font-size:32px; color:#fff; text-decoration:none;">$s_awards</a>
    <a href="can-i-run-it.html" style="font-family:'Oswald'; font-size:32px; color:#fff; text-decoration:none;">$s_runit</a>
    <div id="mobileAuthContainer" style="margin-top: 50px; display: flex; gap: 20px;"></div>
  </div>
"@

$js = @"
    (function() {
      const toggle = document.getElementById('mobileToggle');
      const menu = document.getElementById('mobileMenu');
      const close = document.getElementById('menuCloseBtn');
      if (toggle && menu) {
        toggle.onclick = () => { menu.style.opacity = '1'; menu.style.visibility = 'visible'; menu.classList.add('active'); };
        if (close) close.onclick = () => { menu.style.opacity = '0'; menu.style.visibility = 'hidden'; menu.classList.remove('active'); };
      }
    })();
"@

$files = Get-ChildItem -Path . -Filter *.html
$opt = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase

foreach ($file in $files) {
  Write-Host "Cleaning and Updating $($file.Name)..."
  $c = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
  # 1. Clean existing ডিজাইন tags
  $c = [regex]::Replace($c, '(?s)/\* LUXURY SCALING SYSTEM .*?\*/.*?}', '', $opt)
    
  # 2. Clean orphaned links/divs and fragmented mobile menus
  $c = [regex]::Replace($c, '(?s)<div class="mobile-menu".*?</div>\s*</div>', '', $opt)
  $c = [regex]::Replace($c, '(?s)<div class="mobile-menu".*?</div>', '', $opt)
  $c = [regex]::Replace($c, '(?s)<div class="mobile-toggle".*?</div>', '', $opt)
    
  # 3. Specifically target the "naked" links at the top of body
  $c = [regex]::Replace($c, '(?s)<a href="index.html">.*?</a>\s*<a href="news.html">.*?</a>\s*<a href="games.html">.*?</a>\s*<a href="hardware.html">.*?</a>\s*<a href="reviews.html">.*?</a>\s*<a href="awards.html">.*?</a>\s*<a href="can-i-run-it.html">.*?</a>\s*<div id="mobileAuthContainer".*?</div>\s*</div>', '', $opt)
    
  # 4. Clean Header
  $c = [regex]::Replace($c, '(?s)<header class="topbar".*?</header>', $headerHtml, $opt)
    
  # 5. Inject Modern Styles
  if ($c -match '</style>') {
    $c = $c.Replace('</style>', "$modernStyles`n</style>")
  }
    
  # 6. Inject Correct Mobile Menu
  if ($c -match '<body.*?>') {
    $c = [regex]::Replace($c, '(<body.*?>)', "`$1`n$menuHtml", $opt)
  }
    
  # 7. Inject JS
  if ($c -match '</body>') {
    $c = [regex]::Replace($c, '(<script>\s*\(function\(\)\s*\{.*?\}\)\(\);?\s*</script>)', '', $opt)
    $c = $c.Replace('</body>', "<script>$js</script></body>")
  }
    
  $utf8NoBom = New-Object System.Text.UTF8Encoding $false
  [System.IO.File]::WriteAllText($file.FullName, $c, $utf8NoBom)
}

powershell -ExecutionPolicy Bypass -File sync.ps1
