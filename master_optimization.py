import os

# --- MODERN ULTRA-RESPONSIVE SYSTEM (v3.0) ---
# Supports: Mobile, Tablet, 720p, 1080p, 2K, 4K, Ultra-Wide
# Fixes Georgian Encoding & Z-Index issues

css_payload = """
/* 🚀 GLOBAL DESIGN SCALING SYSTEM */
:root {
    --max-content-width: 1800px; /* Wider for 4K/Wide screens */
    --side-gap: clamp(20px, 6vw, 80px);
}

* { box-sizing: border-box; }

body { 
    overflow-x: hidden; 
    width: 100vw;
    background: #09050d; /* Base safety color */
}

/* --- FRAME SCALING --- */
.frame {
    width: 100% !important;
    max-width: var(--max-content-width) !important;
    margin: 0 auto !important;
    padding: 0 !important;
}

/* --- TOPBAR PERFECTION --- */
.topbar {
    width: 95% !important;
    max-width: 1600px !important;
    margin: 20px auto !important;
    padding: clamp(8px, 1.5vh, 15px) clamp(15px, 3vw, 40px) !important;
    border-radius: 60px !important;
    top: 20px !important;
    display: flex !important;
    justify-content: space-between !important;
    align-items: center !important;
}

/* --- HERO & CONTENT GRID SCALING --- */
.hero-container {
    padding: clamp(20px, 4vh, 40px) var(--side-gap) !important;
}

.slider-wrapper {
    height: clamp(300px, 60vh, 700px) !important;
    border-radius: 40px !important;
}

.slide-title {
    font-size: clamp(24px, 5vw, 68px) !important;
}

.content-grid {
    display: grid !important;
    grid-template-columns: 1fr 380px !important;
    gap: 50px !important;
    padding: 0 var(--side-gap) 100px !important;
    max-width: 100% !important;
}

/* --- RESPONSIVE BREAKPOINTS --- */

/* ULTRA WIDE & 4K */
@media (min-width: 2000px) {
    :root { --max-content-width: 2200px; }
    .slide-title { font-size: 84px !important; }
}

/* DESKTOP (Large) */
@media (max-width: 1440px) {
    .content-grid { grid-template-columns: 1fr 320px !important; gap: 30px !important; }
}

/* TABLET & SMALL LAPTOPS (720p area) */
@media (max-width: 1100px) {
    .content-grid { grid-template-columns: 1fr !important; }
    .nav { display: none !important; }
    .mobile-toggle { display: flex !important; }
}

/* MOBILE PHONES */
@media (max-width: 600px) {
    .topbar { width: 98% !important; top: 10px !important; }
    .auth { display: none !important; }
    .user-badge span { display: none !important; }
    .hero-container { padding: 15px !important; }
    .slider-wrapper { height: 350px !important; border-radius: 24px !important; }
    .content-grid { padding: 0 15px 60px !important; }
}

/* --- MOBILE MENU (FIXED) --- */
.mobile-toggle {
    display: none;
    width: 45px;
    height: 45px;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    gap: 6px;
    cursor: pointer;
    z-index: 10001; /* Above EVERYTHING */
    background: rgba(138, 77, 255, 0.15);
    border: 1px solid var(--accent);
    border-radius: 15px;
    transition: all 0.3s ease;
}

.mobile-toggle span {
    width: 24px;
    height: 2px;
    background: #fff;
    border-radius: 2px;
    transition: 0.3s;
}

.mobile-toggle.active span:nth-child(1) { transform: translateY(8px) rotate(45deg); }
.mobile-toggle.active span:nth-child(2) { opacity: 0; }
.mobile-toggle.active span:nth-child(3) { transform: translateY(-8px) rotate(-45deg); }

.mobile-menu {
    position: fixed;
    inset: 0;
    background: rgba(5, 2, 8, 0.98);
    backdrop-filter: blur(30px);
    z-index: 10000;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 25px;
    opacity: 0;
    visibility: hidden;
    transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.mobile-menu.active {
    opacity: 1;
    visibility: visible;
}

.mobile-menu a {
    font-family: "Oswald";
    font-size: clamp(24px, 8vw, 42px);
    color: #fff;
    text-decoration: none;
    text-transform: uppercase;
    letter-spacing: 3px;
    transition: 0.3s;
}

.mobile-menu a:hover { color: var(--accent); transform: scale(1.1); }
"""

html_menu = """
  <!-- MOBILE MENU -->
  <div class="mobile-menu" id="mobileMenu">
    <a href="index.html">მთავარი</a>
    <a href="news.html">სიახლეები</a>
    <a href="games.html">თამაშები</a>
    <a href="hardware.html">აპარატურა</a>
    <a href="reviews.html">მიმოხილვა</a>
    <a href="awards.html">ჯილდოები</a>
    <a href="can-i-run-it.html">გავქაჩავ?</a>
    <div id="mobileAuthContainer" style="margin-top: 40px; display: flex; gap: 20px;"></div>
  </div>
"""

toggle_html = """
    <div class="mobile-toggle" id="mobileToggle">
      <span></span><span></span><span></span>
    </div>
"""

js_logic = """
    (function() {
      const toggle = document.getElementById('mobileToggle');
      const menu = document.getElementById('mobileMenu');
      const authCont = document.getElementById('mobileAuthContainer');
      const desktopAuth = document.getElementById('authSection');

      if (toggle && menu) {
        toggle.addEventListener('click', (e) => {
          e.stopPropagation();
          const isActive = menu.classList.toggle('active');
          toggle.classList.toggle('active');
          document.body.style.overflow = isActive ? 'hidden' : '';
          
          if (isActive && authCont && desktopAuth && authCont.children.length === 0) {
            authCont.innerHTML = desktopAuth.innerHTML;
          }
        });

        // Close on link click
        menu.querySelectorAll('a').forEach(link => {
          link.addEventListener('click', () => {
            menu.classList.remove('active');
            toggle.classList.remove('active');
            document.body.style.overflow = '';
          });
        });
      }
    })();
"""

# START TRANSFORMATION
html_files = [f for f in os.listdir('.') if f.endswith('.html')]

for filename in html_files:
    try:
        with open(filename, 'r', encoding='utf-8') as f:
            content = f.read()

        # 1. CLEANUP (Remove any old versions of responsive injections)
        content = re.sub(r'/\* 📱 PROJECT-WIDE RESPONSIVE SYSTEM \*/.*?</style>', '</style>', content, flags=re.DOTALL)
        content = re.sub(r'<!-- MOBILE MENU -->.*?</div>', '', content, flags=re.DOTALL)
        content = re.sub(r'<div class="mobile-toggle".*?</div>', '', content, flags=re.DOTALL)
        content = re.sub(r'<script>\s*// --- MOBILE MENU LOGIC ---.*?</script>', '', content, flags=re.DOTALL)
        
        # 2. INJECT CSS
        if '</style>' in content:
            content = content.replace('</style>', css_payload + '\n  </style>')

        # 3. INJECT HTML MENU
        if '<body' in content:
            content = re.sub(r'(<body.*?>)', r'\1\n' + html_menu, content, flags=re.IGNORECASE)

        # 4. INJECT TOGGLE (Inside topbar, after authSection)
        if 'id="authSection"' in content:
            content = re.sub(r'(id="authSection">.*?</div>)', r'\1\n' + toggle_html, content, flags=re.DOTALL)
        elif '</header>' in content:
            content = content.replace('</header>', toggle_html + '\n    </header>')

        # 5. INJECT JS
        if '</body>' in content:
            content = content.replace('</body>', '  <script>\n' + js_logic + '\n  </script>\n</body>')

        with open(filename, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Master Optimization Applied to {filename}")

    except Exception as e:
        print(f"Error on {filename}: {e}")
"""
