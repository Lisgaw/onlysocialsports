# OnlySocialSports — Web Project

Bu klasör iki bileşenden oluşur:
1. **Landing Page** (`index.html`) — Pazarlama sayfası + APK indirme
2. **Flutter Web App** (`web/` klasörü) — Flutter build çıktısı (deploy öncesi oluşturulur)

---

## Proje Yapısı

```
onlysocialsports/
├── index.html          # Landing page (pazarlama + APK download)
├── css/style.css       # Landing page stilleri
├── js/main.js          # Landing page JavaScript
├── vercel.json         # Vercel deployment config
├── package.json        # Proje metadata
├── apk/
│   └── onlysocialsports.apk   # Android APK (build sonrası kopyalanır)
└── web/                        # Flutter web build (build sonrası kopyalanır)
    ├── index.html
    ├── flutter.js
    ├── flutter_bootstrap.js
    └── assets/
```

---

## Deployment Adımları

### 1. Flutter Web Build
```powershell
cd sports_partner_mobile
$env:PATH = "C:\Windows\System32;C:\flutter\bin;$env:PATH"
flutter build web --base-href=/web/ --dart-define=FLAVOR=prod --dart-define=BASE_URL=https://api.onlysocialsport.com/api --release
```

### 2. Flutter Build Çıktısını Kopyala
```powershell
# Flutter web build çıktısını 'web/' klasörüne kopyala
Copy-Item -Recurse -Force "sports_partner_mobile\build\web\*" "onlysocialsports\web\"
```

### 3. APK Kopyala
```powershell
# Release APK'yı 'apk/' klasörüne kopyala
Copy-Item "sports_partner_mobile\build\app\outputs\flutter-apk\app-release.apk" "onlysocialsports\apk\onlysocialsports.apk"
```

### 4. js/main.js'deki APP_URL'i Güncelle
`js/main.js` içindeki `APP_URL` değişkenini doğru URL ile güncelle:
```javascript
const APP_URL = 'https://onlysocialsport.com/web/';
```

### 5. GitHub'a Push
```bash
cd onlysocialsports
git init
git remote add origin https://github.com/Lisgaw/onlysocialsports.git
git add .
git commit -m "feat: initial deployment"
git push -u origin main
```

### 6. Vercel Deployment
- vercel.com → New Project → GitHub → Lisgaw/onlysocialsports
- Framework: Other (Static Site)
- Root Directory: ./
- Deploy!

---

## Backend API

Backend API ayrı bir Vercel projesi olarak deploy edilir.
Backend repo: `Lisgaw/onlysocialsports-api`
API URL: `https://onlysocialsports-api.vercel.app`

### Backend Env Vars (Vercel Dashboard)
```
SUPABASE_URL=https://[YENİ_PROJE_ID].supabase.co
SUPABASE_SERVICE_KEY=[service_role_key]
SUPABASE_ANON_KEY=[anon_key]
JWT_SECRET=[güçlü_rastgele_string]
NODE_ENV=production
```

---

## Supabase Bilgileri

- **Hesap**: yusuf.kucukugurlu@gmail.com
- **Organizasyon**: Lisgaw
- **Proje Adı**: onlysocialsports
- **Bölge**: Frankfurt (eu-central-1)
- **Veritabanı**: `backend/db/migrations/001_initial_schema.sql` çalıştırılmalı
