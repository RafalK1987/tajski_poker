# Pełna paczka 2.2.1 — naprawione wybieranie kart

Usunięto błąd `selected.size is not a function`, który przerywał obsługę kliknięcia karty. Kartę zaznaczasz kliknięciem lub dotknięciem, a następnie wybierasz „Zagraj”. Wybór jest dostępny po rozdaniu, podczas Twojej tury. Aby przebić stół, wybierz silniejszy układ o tej samej liczbie kart; jeśli nie możesz, wybierz „Pas”. Przeciąganie kart na stół nie jest obsługiwane.

## Aktualizacja Twojej istniejącej gry

1. Zachowaj stary folder projektu, szczególnie `.secrets` (prywatna kopia klucza) i `data` (ewentualna lokalna baza).
2. Rozpakuj tę pełną paczkę do NOWEGO folderu. Możesz skopiować do niego swój dotychczasowy folder `.secrets`, aby zachować prywatną kopię klucza. Nie wysyłaj go na GitHub.
3. `wrangler.jsonc` jest już uzupełniony Twoim adresem oraz identyfikatorem istniejącej bazy. To paczka przygotowana dla Twojego wdrożenia, nie uniwersalny szablon.
4. Otwórz PowerShell w nowym folderze `TajskiPoker_Online` i wykonaj:

```powershell
npm ci
npm run deploy
```

Użyj Node.js 24 lub nowszego zgodnie z wymaganiami projektu. Jeśli Cloudflare poprosi o ponowne logowanie, wykonaj `npx wrangler login` na tym samym koncie co poprzednio, a potem ponów publikację.

Nie uruchamiaj ponownie `setup:auth` w nowym folderze bez dotychczasowej kopii klucza! Sekret AUTH_PEPPER jest już zapisany na Cloudflare i zwykły deploy go zachowuje. Nie trzeba tworzyć bazy ani uruchamiać migracji. Konta i mecze online są w dotychczasowej bazie D1.

5. Otwórz https://tajski-poker.rafal-klodos-tajski-poker.workers.dev i odśwież Ctrl+F5. Wersja 2.2.1 ma także nowy adres pliku aplikacji, aby przeglądarka pobrała poprawiony kod.
6. Wybierz „Trening · 3 graczy” albo „Trening · 4 graczy”, poczekaj na „Twoja tura”, kliknij kartę i „Zagraj”. Zaznaczona karta powinna się podnieść, a licznik przy „Zagraj” pokazać liczbę wybranych kart.

Paczka zawiera całą grę, grafikę, serwer, testy, widoczne wymagania loginu i hasła oraz folder `docs` z przekierowaniem GitHub Pages. Publikację adresu GitHuba opisuje `AKTUALIZACJA_I_GITHUB.md`; nie musisz wykonywać ponownie części dotyczącej kopiowania pojedynczych plików, jeśli używasz tej pełnej paczki.

Przeprowadzono testy kliknięć formularza gry w środowisku DOM: zaznaczenie, odznaczenie, zagranie i odpowiedzi botów dla 3 i 4 graczy. Błąd starej wersji został także odtworzony w przeglądarce na Twojej publicznej stronie. Nowa wersja wymaga publikacji powyższą komendą — nie została zdalnie wdrożona na Twoje konto.
