# Dla Rafała — aktualizacja i link GitHuba

## 1. Dodaj wymagania loginu i hasła do działającej gry

W rozpakowanej paczce znajdziesz folder `public`. Skopiuj z niego do folderu `public` w swoim DOTYCHCZASOWYM projekcie cztery pliki:

- index.html
- app.mjs
- style.css
- auth-validation.mjs (nowy plik)

Zastąp trzy istniejące pliki. Nie nadpisuj swojego `wrangler.jsonc`. Nie usuwaj folderu `.secrets` i nie twórz nowego klucza. W swoim dotychczasowym folderze projektu wykonaj:

```powershell
npm run deploy
```

Nie trzeba ponownie instalować pakietów, tworzyć bazy ani wykonywać migracji. Po wdrożeniu odśwież stronę Ctrl+F5. Istniejące konta i mecze pozostają w bazie.

Widoczne wymagania: login 3–24 znaki, litery A–Z, cyfry lub `_`; hasło 12–128 znaków. Przy błędzie pojawia się polski komunikat pod odpowiednim polem. Przycisk „Pokaż hasło” ułatwia sprawdzenie wpisanego tekstu. Walidacja serwera nadal obowiązuje.

## 2. Uruchom https://rafalk1987.github.io/tajski-poker/

To gotowe PRZEKIEROWANIE do Twojej gry. Po wejściu adres w pasku zmieni się na Cloudflare. Gra i konta pozostają na dotychczasowym serwerze.

1. Zaloguj się do GitHuba jako RafalK1987.
2. Utwórz publiczne repozytorium o nazwie dokładnie `tajski-poker`, jeśli jeszcze go nie ma.
3. Wgraj folder `docs` z paczki do głównego folderu repozytorium. Mają powstać pliki `docs/index.html` i `docs/redirect.js`. W przeglądarce GitHuba możesz wybrać Add file → Upload files i przeciągnąć cały folder `docs`, a następnie Commit changes. Jeśli repozytorium jest puste, użyj opcji przesłania istniejących plików na stronie startowej repozytorium.
4. Wejdź w repozytorium → Settings → Pages.
5. W Build and deployment ustaw Source: Deploy from a branch.
6. Wybierz gałąź `main` i folder `/docs`, następnie Save. Jeśli Twoja gałąź główna nazywa się inaczej, wybierz ją zamiast main.
7. Poczekaj na zakończenie publikacji. Adres pojawi się w ustawieniach Pages.

Dla samego przekierowania wystarczy folder `docs` — nie musisz umieszczać reszty projektu w repozytorium. Jeśli wgrywasz także kod gry, pomiń `.secrets`, `.env`, `.dev.vars`, `data`, `.wrangler` i `node_modules`. GitHub nie potrzebuje Twoich kluczy ani kont graczy.

Dokumentacja GitHub Pages: https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site

Nie opublikowano tych plików na Twoim GitHubie automatycznie. Powyższy adres zacznie działać po wykonaniu kroków w Twoim repozytorium.
