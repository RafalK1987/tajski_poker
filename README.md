# Tajski Poker — proste logowanie

**Pełna paczka dla Rafała: najpierw przeczytaj `ZACZNIJ_TUTAJ.md`. Masz już działającą bazę i klucz, więc nie wykonuj ponownie instrukcji pierwszej instalacji poniżej.**

**Masz już działającą grę na Cloudflare? Zacznij od `AKTUALIZACJA_I_GITHUB.md`: opisuje aktualizację formularza i włączenie adresu rafalk1987.github.io/tajski-poker/.**

Wersja 2.2.1. Gracz otwiera link, wpisuje **login i hasło**, klika **Utwórz konto**, a potem gra. Przy kolejnej wizycie wybiera **Zaloguj się**. Nie musi mieć GitHuba, Google, ChatGPT ani podawać e-maila.

Wygląd Royal Lounge, karty, zasady i pokoje dla 3/4 graczy pozostają takie same. GitHub służy wyłącznie Tobie do przechowywania kodu. Konta i mecze zapisuje serwer.

## Najpierw możesz sprawdzić na komputerze

Zainstaluj Node.js 24, rozpakuj ZIP i otwórz terminal w folderze projektu:

```sh
npm ci
npm start
```

Otwórz `http://localhost:3000`, wybierz **Graj ze znajomymi → Utwórz konto**. To lokalny adres testowy, nie publiczny link. Wariant Node.js i hosting Cloudflare mają oddzielne bazy — konta założone lokalnie nie przenoszą się automatycznie do internetu.

## Publiczny link: Cloudflare Workers + D1

Potrzebujesz własnego konta Cloudflare. Nie tworzysz aplikacji OAuth ani logowania GitHub.

1. W folderze projektu wykonaj:

```sh
npm ci
npx wrangler login
npx wrangler d1 create tajski-poker
```

2. W pliku `wrangler.jsonc` zastąp `UZUPELNIJ_ID_BAZY` identyfikatorem `database_id` zwróconym przez ostatnią komendę. Zachowaj nazwę powiązania `DB`.

3. Utwórz tabele i opublikuj stronę:

```sh
npm run db:remote
npm run deploy
```

Cloudflare poda Twój adres `https://tajski-poker.TWOJA-SUBDOMENA.workers.dev`. Jeśli to pierwsze wdrożenie, może poprosić o wybór subdomeny. Nie kupujesz własnej domeny.

4. Wpisz rzeczywisty adres w `PUBLIC_ORIGIN` w pliku `wrangler.jsonc`, bez końcowego ukośnika. Następnie:

```sh
npm run setup:auth
npm run deploy
```

`setup:auth` automatycznie tworzy prywatny klucz zabezpieczający hasła i zapisuje go jako sekret `AUTH_PEPPER` w Cloudflare. Zachowuje też prywatną kopię w `.secrets/auth-pepper.txt`. Nie wyświetla klucza i nie wysyła go do GitHuba. Zachowaj bezpieczną kopię tego pliku: nie usuwaj ani nie zmieniaj klucza po założeniu kont, bo dotychczasowe hasła przestaną działać. Ponowne uruchomienie komendy z istniejącym plikiem używa tego samego klucza.

5. Otwórz swój publiczny adres, załóż konto i sprawdź logowanie. Utwórz stół, skopiuj zaproszenie i wyślij znajomym. Oni zakładają konta bezpośrednio w grze. Do rozpoczęcia potrzeba 3 albo 4 osobnych kont, zgodnie z rozmiarem pokoju.

## Co jest darmowe i jakie są ograniczenia

Cloudflare ma plan Workers Free i D1 Free. Dokumentacja sprawdzona 20.09.2026 podaje 100 tys. żądań dziennie i limit 10 ms CPU na wywołanie Workera; D1 ma m.in. 5 mln odczytanych oraz 100 tys. zapisanych wierszy dziennie. Czterech graczy przy odpytywaniu co 1,5 sekundy generuje około 9600 odpytań na godzinę, plus pozostałe działania.

Plan darmowy ma limity — nie jest hostingiem bez ograniczeń. Sprawdź zużycie oraz logowanie po wdrożeniu na swoim koncie, szczególnie czas CPU operacji hasłowych. Lokalny test nie potwierdza zmieszczenia się w produkcyjnym limicie CPU. Gdy limit będzie przekraczany, użyj serwera Node.js z tej paczki albo planu o wyższym limicie; nie zmniejszaj zabezpieczeń haseł. Nie włączaj planu płatnego, jeśli nie akceptujesz jego kosztów.

Źródła: [Workers — limity i ceny](https://developers.cloudflare.com/workers/platform/pricing/), [D1 — limity i ceny](https://developers.cloudflare.com/d1/platform/pricing/).

## Wgranie na własny GitHub

Utwórz puste repozytorium, np. `tajski-poker`, i wgraj zawartość rozpakowanego folderu. Możesz użyć GitHub Desktop lub terminala:

```sh
git init
git add .
git commit -m "Tajski Poker - proste konta"
git branch -M main
git remote add origin https://github.com/TWOJ_LOGIN/tajski-poker.git
git push -u origin main
```

Zastąp `TWOJ_LOGIN` swoją nazwą. Nigdy nie wgrywaj `.secrets`, `.env`, `.dev.vars`, `data`, `.wrangler`, baz danych ani tokenów. `.gitignore` wyklucza je przy użyciu Git. Ręczne przesyłanie plików przez stronę GitHuba wymaga pominięcia tych folderów samodzielnie.

Sam GitHub Pages nie uruchomi serwera logowania ani pokoi. Znajomym wysyłasz link Cloudflare.

Aktualizacje gry:

```sh
npm run db:remote
npm run deploy
```

Opcjonalny workflow **Deploy Cloudflare** w GitHub Actions wymaga sekretów repozytorium `CLOUDFLARE_API_TOKEN` i `CLOUDFLARE_ACCOUNT_ID`. Token powinien mieć prawa do edycji Workers i D1 na Twoim koncie. Sekret `AUTH_PEPPER` ustawiasz raz na Workerze; nie umieszczasz go w repozytorium.

## Konta i zasady

- Login: 3–24 litery bez polskich znaków, cyfry albo `_`. Wielkość liter nie rozróżnia kont.
- Hasło: 12–128 znaków; może być prostą do zapamiętania dłuższą frazą.
- Sesja trwa do 7 dni lub do wylogowania. Po powrocie możesz otworzyć swój pokój.
- Rejestracja i logowanie mają ograniczenie częstotliwości. Przy zbyt wielu próbach poczekaj 10 minut.
- Nie ma odzyskiwania hasła przez e-mail, ponieważ nie zbieramy adresów e-mail. Zapisz hasło w menedżerze haseł.
- Opuszczenie aktywnego pokoju kończy mecz wszystkim; samo menu nie zatrzymuje czasu na ruch.

Hasła nie są przechowywane otwartym tekstem. Worker stosuje losową sól, HMAC z osobnym sekretem i PBKDF2-SHA256 (100 tys. iteracji, limit Web Crypto środowiska Workers). Sekret jest oddzielony od bazy. Wariant Node.js używa scrypt. Cookies sesyjne są HttpOnly i SameSite=Lax, w publicznym HTTPS także Secure. Serwer sprawdza uprawnienia, ruchy oraz własność kart; nie wysyła przeciwnikom cudzych kart.

## Testowanie i stan dostawy

```sh
npm test
npm run build
npm run cf:check
```

Testy obejmują pełne mecze, rejestrację, powtarzające się loginy, złe hasła, sesje, wylogowanie, ograniczanie prób, CSRF i dostęp do pokoi. `cf:check` sprawdza pakowanie Workera bez publikacji. Paczka nie jest wdrożona na Twoim koncie; rzeczywiste działanie i limity Cloudflare wymagają sprawdzenia po wykonaniu konfiguracji powyżej.

Jeśli aktualizujesz wcześniejsze wdrożenie GitHub OAuth, wykonaj migracje, ustaw klucz i opublikuj nową wersję. Istniejące konta OAuth nie mają haseł: ich użytkownicy zakładają nowe konta. Stare mecze nie są automatycznie przypisywane do nowych kont. Nie usuwaj bazy przy aktualizacji.

Dodatkowa instrukcja własnego serwera Node.js/Docker: `README_NODE.md`.
