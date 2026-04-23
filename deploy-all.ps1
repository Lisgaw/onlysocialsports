# OnlySocialSports — Tam Deployment Script
# Çalıştırmadan önce: Supabase ve Vercel projelerini oluşturun
# Kullanım: .\deploy-all.ps1

param(
    [string]$SupabaseUrl = "",
    [string]$SupabaseServiceKey = "",
    [string]$SupabaseAnonKey = "",
    [string]$JwtSecret = ""
)

$ErrorActionPreference = "Stop"
$ROOT = "C:\Users\yusuf\Desktop\Programlar\projetest"
$MOBILE = "$ROOT\sports_partner_mobile"
$WEB = "$ROOT\onlysocialsports"
$API = "$ROOT\onlysocialsports-api"

$env:PATH = "C:\Windows\System32;C:\Windows;C:\Windows\System32\WindowsPowerShell\v1.0;C:\Program Files\Git\cmd;C:\flutter\bin;" + $env:PATH

Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  OnlySocialSports — Full Deployment Setup" -ForegroundColor Cyan  
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# ── STEP 1: Validate params ──────────────────────────────
if (-not $SupabaseUrl -or -not $SupabaseServiceKey -or -not $JwtSecret) {
    Write-Host "⚠️  Env vars belirtilmemiş. Lütfen Supabase bilgilerini girin:" -ForegroundColor Yellow
    if (-not $SupabaseUrl) { $SupabaseUrl = Read-Host "   SUPABASE_URL (https://xxx.supabase.co)" }
    if (-not $SupabaseServiceKey) { $SupabaseServiceKey = Read-Host "   SUPABASE_SERVICE_KEY (service_role)" }
    if (-not $SupabaseAnonKey) { $SupabaseAnonKey = Read-Host "   SUPABASE_ANON_KEY (anon)" }
    if (-not $JwtSecret) { $JwtSecret = Read-Host "   JWT_SECRET (min 32 karakter)" }
}

# ── STEP 2: Build Flutter Web ────────────────────────────
Write-Host ""
Write-Host "[1/5] Flutter Web build yapılıyor..." -ForegroundColor Green
Push-Location $MOBILE
& C:\flutter\bin\flutter.bat build web `
    --base-href=/web/ `
    --dart-define=FLAVOR=prod `
    "--dart-define=BASE_URL=https://onlysocialsports-api.vercel.app/api" `
    --release
Pop-Location
Write-Host "✅ Flutter Web build tamamlandı" -ForegroundColor Green

# ── STEP 3: Copy Flutter Web to web/ ────────────────────
Write-Host ""
Write-Host "[2/5] Flutter Web dosyaları kopyalanıyor..." -ForegroundColor Green
$webOut = "$MOBILE\build\web"
$webDest = "$WEB\web"
if (Test-Path $webDest) { Remove-Item -Recurse -Force $webDest }
New-Item -ItemType Directory -Force -Path $webDest | Out-Null
Copy-Item -Recurse -Force "$webOut\*" "$webDest\"
Write-Host "✅ Flutter Web → $webDest" -ForegroundColor Green

# ── STEP 4: Build Release APK ────────────────────────────
Write-Host ""
Write-Host "[3/5] Release APK build yapılıyor..." -ForegroundColor Green
Push-Location $MOBILE
& C:\flutter\bin\flutter.bat build apk `
    --dart-define=FLAVOR=prod `
    "--dart-define=BASE_URL=https://onlysocialsports-api.vercel.app/api" `
    --release
Pop-Location
$apkSrc = "$MOBILE\build\app\outputs\flutter-apk\app-release.apk"
$apkDest = "$WEB\apk\onlysocialsports.apk"
Copy-Item -Force $apkSrc $apkDest
Write-Host "✅ Release APK → $apkDest ($([math]::Round((Get-Item $apkDest).Length / 1MB, 1)) MB)" -ForegroundColor Green

# ── STEP 5: Update js/main.js with correct APP_URL ──────
Write-Host ""
Write-Host "[4/5] main.js APP_URL güncelleniyor..." -ForegroundColor Green
$mainJs = "$WEB\js\main.js"
$content = Get-Content $mainJs -Raw
$content = $content -replace "const APP_URL = '.*?';", "const APP_URL = 'https://onlysocialsports.vercel.app/web/';"
Set-Content $mainJs $content -Encoding UTF8
Write-Host "✅ APP_URL → https://onlysocialsports.vercel.app/web/" -ForegroundColor Green

# ── STEP 6: Create .env for backend ─────────────────────
Write-Host ""
Write-Host "[5/5] Backend API .env oluşturuluyor..." -ForegroundColor Green
$envContent = @"
SUPABASE_URL=$SupabaseUrl
SUPABASE_SERVICE_KEY=$SupabaseServiceKey
SUPABASE_ANON_KEY=$SupabaseAnonKey
JWT_SECRET=$JwtSecret
NODE_ENV=production
"@
Set-Content "$API\.env" $envContent -Encoding UTF8
Write-Host "✅ $API\.env oluşturuldu" -ForegroundColor Green

Write-Host ""
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ✅ Hazırlık tamamlandı! Sıradaki adımlar:" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. GitHub'a push (onlysocialsports-api):" -ForegroundColor Yellow
Write-Host "   cd $API"
Write-Host "   git init && git add . && git commit -m 'initial'"
Write-Host "   git remote add origin https://github.com/Lisgaw/onlysocialsports-api.git"
Write-Host "   git push -u origin main"
Write-Host ""
Write-Host "2. GitHub'a push (onlysocialsports web):" -ForegroundColor Yellow
Write-Host "   cd $WEB"
Write-Host "   git init && git add . && git commit -m 'initial'"
Write-Host "   git remote add origin https://github.com/Lisgaw/onlysocialsports.git"
Write-Host "   git push -u origin main"
Write-Host ""
Write-Host "3. Vercel projelerini GitHub'a bağla:" -ForegroundColor Yellow
Write-Host "   - vercel.com → New Project → Lisgaw/onlysocialsports-api"
Write-Host "   - vercel.com → New Project → Lisgaw/onlysocialsports"
Write-Host ""
Write-Host "4. Vercel env vars ekle (onlysocialsports-api):" -ForegroundColor Yellow
Write-Host "   SUPABASE_URL, SUPABASE_SERVICE_KEY, SUPABASE_ANON_KEY, JWT_SECRET"
Write-Host ""
