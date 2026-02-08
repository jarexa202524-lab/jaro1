# MASTER SLIDER UPGRADE v2.1 - SWIPE & CONTROLS
$files = Get-ChildItem -Path . -Filter *.html

$sliderCss = @"

/* MODERNIST SLIDER CONTROLS */
.slider-wrapper { cursor: grab; }
.slider-wrapper:active { cursor: grabbing; }

.slider-nav {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 50px;
  height: 50px;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  color: #fff;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 10;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-size: 20px;
  user-select: none;
}
.slider-nav:hover {
  background: var(--accent);
  border-color: var(--accent);
  box-shadow: 0 0 20px var(--accent-glow);
}
.slider-nav.prev { left: 20px; }
.slider-nav.next { right: 20px; }

.slider-dots {
  position: absolute;
  bottom: 25px;
  right: 60px;
  display: flex;
  gap: 12px;
  z-index: 10;
}
.dot {
  width: 8px;
  height: 8px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.4s ease;
}
.dot.active {
  width: 30px;
  background: var(--accent);
  border-radius: 10px;
  box-shadow: 0 0 15px var(--accent-glow);
}
@media (max-width: 600px) {
  .slider-nav { display: none; }
  .slider-dots { right: 50%; transform: translateX(50%); bottom: 15px; }
}
"@

$sliderHtml = @"
        <div class="slider-nav prev" id="prevSlide">&#10094;</div>
        <div class="slider-nav next" id="nextSlide">&#10095;</div>
        <div class="slider-dots" id="sliderDots"></div>
"@

$sliderJs = @"
    // UPGRADED SLIDER LOGIC (Swipe + Navigation)
    (function() {
      const wrapper = document.getElementById('heroSlider');
      if (!wrapper) return;
      const slides = wrapper.querySelectorAll('.slide');
      const dotsCont = document.getElementById('sliderDots');
      const prevBtn = document.getElementById('prevSlide');
      const nextBtn = document.getElementById('nextSlide');
      let cur = 0;
      let startX = 0;
      let isDragging = false;
      let timer = null;

      // Init Dots
      if (dotsCont && dotsCont.children.length === 0) {
        slides.forEach((_, i) => {
          const d = document.createElement('div');
          d.className = 'dot' + (i === 0 ? ' active' : '');
          d.onclick = () => goTo(i);
          dotsCont.appendChild(d);
        });
      }

      const update = () => {
        slides.forEach((s, i) => s.classList[i === cur ? 'add' : 'remove']('active'));
        if (dotsCont) {
          dotsCont.querySelectorAll('.dot').forEach((d, i) => d.classList[i === cur ? 'add' : 'remove']('active'));
        }
      };

      const goTo = (n) => {
        cur = (n + slides.length) % slides.length;
        update();
        resetTimer();
      };

      const next = () => goTo(cur + 1);
      const prev = () => goTo(cur - 1);

      if (prevBtn) prevBtn.onclick = (e) => { e.stopPropagation(); next(); };
      if (nextBtn) nextBtn.onclick = (e) => { e.stopPropagation(); next(); };

      const resetTimer = () => {
        clearInterval(timer);
        timer = setInterval(next, 7000);
      };
      resetTimer();

      // Swipe / Drag Logic
      const handleStart = (e) => {
        startX = e.type.includes('mouse') ? e.pageX : e.touches[0].clientX;
        isDragging = true;
      };
      const handleEnd = (e) => {
        if (!isDragging) return;
        const endX = e.type.includes('mouse') ? e.pageX : e.changedTouches[0].clientX;
        const diff = startX - endX;
        if (Math.abs(diff) > 50) diff > 0 ? next() : prev();
        isDragging = false;
      };

      wrapper.addEventListener('mousedown', handleStart);
      wrapper.addEventListener('touchstart', handleStart, {passive: true});
      window.addEventListener('mouseup', handleEnd);
      wrapper.addEventListener('touchend', handleEnd, {passive: true});
    })();
"@

foreach ($file in $files) {
    $c = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    if ($c -match 'id="heroSlider"') {
        # CLEANUP OLD SLIDER JS
        $c = [regex]::Replace($c, '(?s)// SLIDER.*?// COUNTDOWNS', "// COUNTDOWNS", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        
        # INJECT CSS
        if ($c -match '</style>' -and $c -notmatch 'MODERNIST SLIDER CONTROLS') {
            $c = $c.Replace('</style>', "$sliderCss`n</style>")
        }
        
        # INJECT HTML
        if ($c -match '<div class="slider-wrapper" id="heroSlider">') {
            if ($c -notmatch 'slider-dots') {
                $target = '<div class="slider-wrapper" id="heroSlider">'
                $c = $c.Replace($target, "$target`n$sliderHtml")
            }
        }
        
        # INJECT JS
        if ($c -match '</body>' -and $c -notmatch 'UPGRADED SLIDER LOGIC') {
            $c = $c.Replace('</body>', "<script>$sliderJs</script></body>")
        }

        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($file.FullName, $c, $utf8NoBom)
        Write-Host "Upgraded slider on: $($file.Name)"
    }
}
