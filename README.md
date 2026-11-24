# Instrukcja konfiguracji dostępu SSH dla użytkowników w QNAP

Aby umożliwić użytkownikom logowanie się do serwera QNAP przez SSH, należy wykonać poniższe kroki.

### 1. Utworzenie użytkownika i nadanie uprawnień do folderu

1. Zaloguj się do panelu administracyjnego QNAP (QTS).
2. Przejdź do **Panel sterowania → Uprawnienia → Użytkownicy**.
3. Utwórz nowego użytkownika lub wybierz istniejącego.
4. Przejdź do ustawień uprawnień folderów współdzielonych.
5. Nadaj wybranemu użytkownikowi uprawnienia **Read/Write** do folderu, do którego ma mieć dostęp.

### 2. Logowanie przez SSH jako administrator

1. Połącz się z serwerem QNAP przez SSH, używając konta administratora (np. `admin`).

   ```bash
   ssh admin@ADRES_IP_QNAP
   ```

2. Po zalogowaniu przejdź do konfiguracji SSH.

### 3. Dodanie użytkownika do konfiguracji SSHD

1. Otwórz plik konfiguracyjny:

   ```bash
   vi /etc/config/ssh/sshd_config
   ```

2. Znajdź parametr `AllowUsers`.
3. Dodaj nazwę użytkownika do istniejącej listy, oddzielając ją spacją.

   Przykład:

   ```text
   AllowUsers admin qnap backupuser nowy_uzytkownik
   ```

4. Sprawdź również plik:

   ```bash
   vi /etc/config/ssh/sshd_user_config
   ```

5. Jeżeli znajduje się w nim parametr `AllowUsers`, upewnij się, że użytkownik również jest uwzględniony na liście.

**Ważne:** Nie usuwaj istniejących użytkowników z listy `AllowUsers`. Dodaj jedynie nowego użytkownika.

### 4. Ponowne uruchomienie usługi SSH przez interfejs WWW

Po zmianie konfiguracji należy zrestartować usługę SSH.

1. Zaloguj się do interfejsu WWW QTS.
2. Przejdź do **Panel sterowania → Sieć i usługi plików → Telnet / SSH**.
3. Wyłącz usługę SSH.
4. Zastosuj zmiany i poczekaj, aż usługa zostanie wyłączona.
5. Ponownie włącz usługę SSH.

**Ważne:** Restart SSH należy wykonać przez interfejs WWW QTS, poprzez wyłączenie i ponowne włączenie usługi, a nie przez restart procesu z poziomu terminala.

### 5. Weryfikacja połączenia

Po ponownym uruchomieniu SSH sprawdź połączenie z nowego konta:

```bash
ssh nazwa_uzytkownika@ADRES_IP_QNAP
```

Po zalogowaniu sprawdź, czy użytkownik ma dostęp do odpowiedniego folderu oraz może odczytywać i zapisywać pliki zgodnie z nadanymi uprawnieniami.

**Uwaga:** Zmiany w plikach konfiguracyjnych SSH na QNAP mogą zostać nadpisane podczas aktualizacji systemu lub restartu urządzenia. Po takich operacjach należy zweryfikować konfigurację.