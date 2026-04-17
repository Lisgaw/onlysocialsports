Flutter web build çıktısı buraya kopyalanacak.

Komut:
  flutter build web --dart-define=FLAVOR=prod --dart-define=BASE_URL=https://onlysocialsports-api.vercel.app/api --release
  Copy-Item -Recurse -Force "build\web\*" "..\onlysocialsports\web\"
