import os
import re

css_content = """
/* 📱 PROJECT-WIDE RESPONSIVE SYSTEM */

:root {
  --nav-height: 80px;
}

/* Base Responsive Fixes */
.frame {
  width: 100%;
  max-width: 1440px;
  margin: 0 auto;
  padding: 0;
}

/* TOPBAR RESPONSIVE */
@media (max-width: 1024px) {
  .topbar {
    width: 96% !important;
    margin: 10px auto !important;
    top: 10px !important;
    padding: 8px 15px !important;
  }
  
  .nav {
    display: none !important;
  }
  
  .auth {
    min-width: unset !important;
    gap: 8px !important;
  }
  
  .auth-btn {
    padding: 8px 16px !important;
    font-size: 11px !important;
  }
  
  .mobile-toggle {
    display: flex !important;
  }
}

@media (max-width: 500px) {
  .logo span {
    font-size: 16px !important;
  }
  .logo small {
    display: none !important;
  }
  .auth {
    display: none !important; /* Hide on mobile phones to prioritize menu */
  }
  .user-badge span {
    display: none !important;
  }
}

/* MOBILE TOGGLE BUTTON */
.mobile-toggle {
  display: none;
  width: 40px;
  height: 40px;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 5px;
  cursor: pointer;
  z-index: 1100;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  margin-left: 10px;
}

.mobile-toggle span {
  width: 20px;
  height: 2px;
  background: #fff;
  border-radius: 2px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.mobile-toggle.active span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
.mobile-toggle.active span:nth-child(2) { opacity: 0; }
.mobile-toggle.active span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }

/* MOBILE MENU OVERLAY */
.mobile-menu {
  position: fixed;
  inset: 0;
  background: rgba(9, 5, 13, 0.98);
  backdrop-filter: blur(25px);
  z-index: 9999;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 25px;
  opacity: 0;
  visibility: hidden;
  transition: all 0.4s ease;
}

.mobile-menu.active {
  opacity: 1;
  visibility: visible;
}

.mobile-menu a {
  font-family: "Oswald";
  font-size: 32px;
  color: #fff;
  text-decoration: none;
  text-transform: uppercase;
  letter-spacing: 2px;
}

.mobile-menu a.active {
  color: var(--accent);
}

/* HERO SLIDER RESPONSIVE */
@media (max-width: 1024px) {
  .hero-container {
    padding: 30px 15px !important;
  }
  .slider-wrapper {
    height: 400px !important;
  }
  .slide-title {
    font-size: 38px !important;
  }
}

@media (max-width: 600px) {
  .slider-wrapper {
    height: 320px !important;
  }
  .slide-title {
    font-size: 26px !important;
  }
  .slide-content {
    left: 20px !important;
    bottom: 30px !important;
    max-width: calc(100% - 40px) !important;
  }
}

/* CONTENT GRID RESPONSIVE */
@media (max-width: 1100px) {
  .content-grid {
    grid-template-columns: 1fr !important;
    padding: 0 15px 40px !important;
    gap: 30px !important;
  }
  .news-grid {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)) !important;
  }
}

@media (max-width: 480px) {
  .news-grid {
    grid-template-columns: 1fr !important;
  }
}

/* GLOBAL SCALING */
img { max-width: 100%; height: auto; }
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
    <div id="mobileAuthContainer" style="margin-top: 30px; display: flex; gap: 15px;"></div>
  </div>
"""

toggle_html = """
      <div class="mobile-toggle" id="mobileToggle">
        <span></span>
        <span></span>
        <span></span>
      </div>
"""

js_content = """
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

        menu.querySelectorAll('a').forEach(link => {
          link.addEventListener('click', () => {
            toggle.classList.remove('active');
            menu.classList.remove('active');
            document.body.style.overflow = '';
          });
        });
      }
    })();
"""

html_files = [f for f in os.listdir('.') if f.endswith('.html')]

for filename in html_files:
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. CSS
    if '</style>' in content and 'PROJECT-WIDE RESPONSIVE SYSTEM' not in content:
        content = content.replace('</style>', css_content + '\n  </style>')

    # 2. Menu HTML
    if '<body' in content and 'id="mobileMenu"' not in content:
        content = re.sub(r'(<body.*?>)', r'\1\n' + html_menu, content, flags=re.IGNORECASE)

    # 3. Toggle HTML (Inside Header)
    if '</header>' in content and 'id="mobileToggle"' not in content:
        content = content.replace('</header>', toggle_html + '\n    </header>')

    # 4. JS
    if '</body>' in content and 'MOBILE MENU LOGIC' not in content:
        content = content.replace('</body>', '  <script>\n' + js_content + '\n  </script>\n</body>')
    elif '</html>' in content and 'MOBILE MENU LOGIC' not in content:
        # Fallback if body is missing (shouldn't happen but for safety)
        content = content.replace('</html>', '  <script>\n' + js_content + '\n  </script>\n</html>')

    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Optimized {filename}")
