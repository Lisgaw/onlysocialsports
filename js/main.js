// ═══════════════════════════════════════════════════════════
//   OnlySocialSports — Landing Page JS
// ═══════════════════════════════════════════════════════════

// ── Navbar scroll effect ──────────────────────────────────
const navbar = document.getElementById('navbar');
window.addEventListener('scroll', () => {
  if (window.scrollY > 20) {
    navbar.classList.add('scrolled');
  } else {
    navbar.classList.remove('scrolled');
  }
});

// ── Mobile hamburger menu ─────────────────────────────────
const hamburger = document.getElementById('hamburger');
const mobileMenu = document.getElementById('mobile-menu');

hamburger.addEventListener('click', () => {
  mobileMenu.classList.toggle('open');
});

// Close mobile menu on link click
document.querySelectorAll('.mobile-link').forEach(link => {
  link.addEventListener('click', () => {
    mobileMenu.classList.remove('open');
  });
});

// ── Web App launch handler ────────────────────────────────
// APP_URL will be replaced with actual URL once deployed
const APP_URL = 'https://onlysocialsports-app.vercel.app';

const openAppButtons = ['hero-open-app', 'nav-open-app', 'mobile-open-app', 'launch-webapp'];
openAppButtons.forEach(id => {
  const btn = document.getElementById(id);
  if (btn) {
    btn.addEventListener('click', (e) => {
      // If APP_URL is still placeholder, show info
      if (APP_URL.includes('onlysocialsports-app.vercel.app')) {
        // App is deployed — open in new tab
        window.open(APP_URL, '_blank', 'noopener,noreferrer');
      }
    });
  }
});

// ── Smooth anchor scroll ──────────────────────────────────
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
  anchor.addEventListener('click', function (e) {
    const targetId = this.getAttribute('href');
    if (targetId === '#') return;
    const target = document.querySelector(targetId);
    if (target) {
      e.preventDefault();
      const offset = 70; // navbar height
      const top = target.getBoundingClientRect().top + window.pageYOffset - offset;
      window.scrollTo({ top, behavior: 'smooth' });
    }
  });
});

// ── Intersection Observer for fade-in animations ──────────
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.style.opacity = '1';
      entry.target.style.transform = 'translateY(0)';
    }
  });
}, { threshold: 0.1 });

// Apply initial styles and observe
document.querySelectorAll('.feature-card, .step-card, .webapp-card, .download-card').forEach(el => {
  el.style.opacity = '0';
  el.style.transform = 'translateY(20px)';
  el.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
  observer.observe(el);
});
