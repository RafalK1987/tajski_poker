# Tajski Poker — Royal Lounge Online

Gra przeglądarkowa dla 3 lub 4 osób. Zachowuje karty, zielono-złoty stół i zasady wersji Royal Lounge. Działa bez instalowania aplikacji na telefonie. Zawiera też trening z botami.

## Co dostajesz

- Konta na login i hasło w samodzielnie uruchomionej wersji Node.js.
- Prywatne pokoje, kod i link zaproszenia, rozpoczęcie meczu przez gospodarza.
- Serwerowe tasowanie, sprawdzanie ruchów, ukryte karty przeciwników i wspólny wynik.
- 10 rozdań, po 16 kart dla 3 osób lub po 12 dla 4 osób.
- Zapis w SQLite: odświeżenie przeglądarki i ponowne uruchomienie serwera nie kasują meczu.
- 90 sekund na ruch. Po upływie czasu serwer pasuje; na pustym stole wykonuje poprawne zagranie. Upływ czasu jest rozliczany przy następnym odczycie pokoju, więc całkowicie opuszczony stół zaczeka do powrotu gracza.
- Aktualizacja stołu co około 1,5 sekundy. Brak czatu, publicznego rankingu i wyszukiwarki losowych przeciwników — grasz z zaproszonymi osobami.

## Najważniejsze: GitHub przechowuje kod, serwer uruchamia grę

Możesz umieścić ten projekt we własnym repozytorium GitHub. Sam GitHub Pages nie uruchomi logowania, bazy danych ani meczu online. Link dla graczy musi prowadzić do uruchomionego serwera, np. `https://poker.twoja-domena.pl`.

Nie potrzebujesz Google Play ani App Store. Gracz otwiera link w Chrome lub Safari, zakłada konto i dołącza do pokoju. Hosting i domena są niezależne od repozytorium GitHub; ich koszt zależy od wybranego dostawcy.

## 1. Uruchomienie na własnym komputerze

Zainstaluj Node.js 24 lub nowszy. Rozpakuj projekt, otwórz terminal w jego folderze:

```sh
npm ci
npm start
```

Otwórz `http://localhost:3000`. Wybierz **Graj ze znajomymi**, a następnie **Utwórz konto**. Login: 3–24 litery bez polskich znaków, cyfry lub `_`. Hasło: 12–128 znaków.

Lokalny adres działa na tym komputerze; nie jest linkiem do udostępniania przez internet. Do próby z telefonu w tej samej sieci ustaw `PUBLIC_ORIGIN` na `http://ADRES-IP-KOMPUTERA:3000` i uruchom serwer ponownie. Ten sam adres wpisz na telefonie. Zezwól na połączenia do portu 3000 w zaporze. Jest to tryb testowy, bez HTTPS.

Na macOS/Linux:

```sh
PUBLIC_ORIGIN=http://192.168.1.10:3000 npm start
```

W PowerShell:

```powershell
$env:PUBLIC_ORIGIN="http://192.168.1.10:3000"
npm start
```

Zastąp przykładowe IP adresem swojego komputera.

## 2. Wgranie na swój GitHub

1. Utwórz nowe, puste repozytorium w GitHub, np. `tajski-poker`.
2. Rozpakuj ZIP. Wgraj zawartość folderu projektu, a nie sam ZIP. Możesz użyć GitHub Desktop → Add local repository → Publish repository albo komend poniżej.
3. Nie wgrywaj folderów `node_modules`, `data`, pliku `.env` ani plików bazy danych. `.gitignore` wyklucza je przy użyciu Git.

```sh
git init
git add .
git commit -m "Tajski Poker Online"
git branch -M main
git remote add origin https://github.com/TWOJ_LOGIN/tajski-poker.git
git push -u origin main
```

Wstaw swój login i nazwę repozytorium. Logowanie do GitHub odbywa się przez Twoje narzędzie Git lub GitHub Desktop. Dołączony GitHub Actions sprawdzi grę po wysłaniu zmian; nie publikuje automatycznie serwera.

## 3. Publiczny link — Docker i domena

Wymagania: serwer Linux z Docker Engine i Compose, domena/subdomena wskazująca rekordem A na IP serwera, otwarte porty 80 i 443. Jeśli domena ma rekord AAAA, musi wskazywać poprawny IPv6 tego samego serwera.

Na serwerze pobierz swój projekt:

```sh
git clone https://github.com/TWOJ_LOGIN/tajski-poker.git
cd tajski-poker
cp .env.example .env
```

Edytuj `.env`, ustawiając własną domenę, np. `DOMAIN=poker.mojadomena.pl`. Następnie:

```sh
docker compose up -d --build
```

Caddy obsługuje HTTPS i przekazuje ruch do gry. Poczekaj na uzyskanie certyfikatu. Otwórz `https://TWOJA-DOMENA`. Ten link można wysłać znajomym przez WhatsApp.

Po publikacji sprawdź z dwóch oddzielnych przeglądarek: rejestrację, logowanie, dołączenie do pokoju oraz odzyskanie pokoju po odświeżeniu. Do rozpoczęcia potrzebne są 3 lub 4 konta. Nie można zająć kilku miejsc jednym kontem.

Aktualizacja kodu:

```sh
git pull
docker compose up -d --build
```

Baza jest w trwałym woluminie `poker_data`. Zwykłe ponowne uruchomienie kontenera jej nie usuwa. Nie uruchamiaj `docker compose down -v`, jeśli chcesz zachować konta i mecze. Rób kopie zapasowe bazy przez SQLite backup albo po zatrzymaniu usługi; kopiowanie samego pliku aktywnej bazy w trybie WAL może pominąć najnowsze zapisy.

Alternatywny hosting musi obsługiwać Node.js 24, stale uruchomiony proces i trwały dysk. Ustaw `PUBLIC_ORIGIN=https://TWOJA-DOMENA`, `DB_PATH` na trwałym dysku i `NODE_ENV=production`. Nie używaj ulotnego systemu plików do kont graczy. Ta wersja uruchamia jeden serwer aplikacji; skalowanie na kilka serwerów wymaga wspólnej bazy i dostosowania wdrożenia.

## Jak zagrać

1. Każdy gracz tworzy konto i loguje się na stronie.
2. Jedna osoba wybiera stół dla 3 albo 4 osób.
3. Kopiuje zaproszenie i przesyła je pozostałym.
4. Pozostali otwierają link, logują się, wpisują pseudonim i wybierają **Dołącz do stołu**. Kod z linku jest wypełniony automatycznie.
5. Gospodarz wybiera **Rozpocznij mecz**. Po rozdaniu gospodarz przechodzi do kolejnego.
6. Po rozłączeniu otwórz ponownie grę i wybierz **Wróć do stołu**. Menu nie zatrzymuje czasu gry online. Opuszczenie aktywnego pokoju kończy mecz wszystkim.

## Bezpieczeństwo i ograniczenia

Hasła są haszowane przez scrypt z oddzielną solą. Sesje mają losowe tokeny; baza przechowuje ich skróty. Cookies są HttpOnly i SameSite=Lax, a przy HTTPS także Secure. Zapisy wymagają poprawnego nagłówka Origin. Serwer sprawdza członkostwo, turę, własność kart i wersję stanu. Przeciwnikom przesyła liczbę kart, nigdy ich wartości. Nazwy graczy są walidowane i bezpiecznie wyświetlane.

Nie ma odzyskiwania hasła przez e-mail ani panelu administratora. Zapamiętaj hasło. Dołączona wersja jest przeznaczona do gry ze znajomymi; przed dużym publicznym serwisem potrzebne są m.in. monitoring, procedury kopii zapasowych i zarządzanie kontami.

Ten dokument dotyczy opcjonalnego serwera Node.js z własnym loginem i hasłem. Wdrożenie Cloudflare z loginem i hasłem opisuje README.md. Bazy danych tych dwóch wariantów nie są współdzielone.

## Testy i pliki

```sh
npm test
npm run build
```

Testy obejmują zasady, 60 meczów silnika (600 rozdań), pełne mecze sieciowe dla 3 i 4 kont, ukrywanie kart, ruchy poza turą, podwójne ruchy, sesje i odtwarzanie meczu z bazy. Testy nie zastępują sprawdzenia na fizycznym telefonie ani testu obciążenia publicznego serwera.

- `public/`: kompletna strona, grafika i tryb treningowy.
- `server/node.mjs`: samodzielny serwer z kontami.
- `server/service.mjs`: wspólna logika pokoi i gry online.
- `db/schema.ts`, `drizzle/`: schemat i migracje bazy.
- `Dockerfile`, `compose.yaml`, `Caddyfile`: gotowe wdrożenie HTTPS.
- `.github/workflows/ci.yml`: testy na GitHub.

Nie publikuj bazy kont, aktywnych sesji, haseł, prywatnych kluczy ani plików `.env`. Grafika pochodzi z dostarczonego projektu gry; projekt nie nadaje nowych praw do materiałów źródłowych.
