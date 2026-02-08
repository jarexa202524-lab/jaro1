# GAME DEBATE - FINAL RESPONSIVE OPTIMIZER (UTF8 Safe)

$css = @"
/* 📱 PROJECT-WIDE RESPONSIVE SYSTEM */
@media (max-width: 1024px) {
  .topbar { width: 96% !important; margin: 10px auto !important; top: 10px !important; padding: 8px 15px !important; }
  .nav { display: none !important; }
  .auth { min-width: unset !important; gap: 8px !important; }
  .auth-btn { padding: 8px 16px !important; font-size: 11px !important; }
  .mobile-toggle { display: flex !important; }
}
@media (max-width: 500px) {
  .logo span { font-size: 16px !important; }
  .logo small { display: none !important; }
  .auth { display: none !important; }
  .user-badge span { display: none !important; }
}
.mobile-toggle { display: none; width: 40px; height: 40px; flex-direction: column; justify-content: center; align-items: center; gap: 5px; cursor: pointer; z-index: 1100; background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 12px; margin-left: 10px; }
.mobile-toggle span { width: 20px; height: 2px; background: #fff; border-radius: 2px; transition: all 0.3s ease; }
.mobile-toggle.active span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
.mobile-toggle.active span:nth-child(2) { opacity: 0; }
.mobile-toggle.active span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }
.mobile-menu { position: fixed; inset: 0; background: rgba(9, 5, 13, 0.98); backdrop-filter: blur(25px); z-index: 9999; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 25px; opacity: 0; visibility: hidden; transition: all 0.4s ease; }
.mobile-menu.active { opacity: 1; visibility: visible; }
.mobile-menu a { font-family: "Oswald"; font-size: 28px; color: #fff; text-decoration: none; text-transform: uppercase; letter-spacing: 2px; }
@media (max-width: 1024px) {
  .hero-container { padding: 20px 15px !important; }
  .slider-wrapper { height: 350px !important; }
  .slide-title { font-size: 32px !important; }
}
@media (max-width: 1100px) {
  .content-grid { grid-template-columns: 1fr !important; padding: 0 15px 40px !important; gap: 30px !important; }
}
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
    <div id="mobileAuthContainer" style="margin-top: 20px; display: flex; gap: 10px;"></div>
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
        t.onclick = () => {
          t.classList.toggle('active');
          m.classList.toggle('active');
          document.body.style.overflow = m.classList.contains('active') ? 'hidden' : '';
          if (ac && da && ac.children.length === 0) ac.innerHTML = da.innerHTML;
        };
        m.querySelectorAll('a').forEach(l => {
          l.onclick = () => {
            t.classList.remove('active');
            m.classList.remove('active');
            document.body.style.overflow = '';
          };
        });
      }
    })();
"@

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    # Read with UTF8 specifically
    $c = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    if ($c -match '</style>') { $c = $c.Replace('</style>', "$css`n</style>") }
    if ($c -match '<body.*?>') { $c = [regex]::Replace($c, '(<body.*?>)', "`$1`n$menuHtml") }
    if ($c -match '</header>') { $c = $c.Replace('</header>', "$toggleHtml`n</header>") }
    if ($c -match '</body>') { $c = $c.Replace('</body>', "<script>$js</script></body>") }
    
    # Write back with UTF8 NO BOM (standard for web)
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($file.FullName, $c, $utf8NoBom)
    Write-Host "Optimized: $($file.Name)"
}
