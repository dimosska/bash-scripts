# Instrukcja konfiguracji dostępu SSH dla użytkowników w QNAP

Celem instrukcji jest umożliwienie wybranemu użytkownikowi logowania się do QNAP przez SSH oraz uzyskanie dostępu do odpowiedniego folderu współdzielonego.

## Utworzenie użytkownika i nadanie uprawnień

Zaloguj się do panelu administracyjnego QNAP (QTS).

Przejdź do **Panel sterowania → Uprawnienia → Użytkownicy**.

Utwórz nowego użytkownika lub wybierz istniejącego.

Przejdź do ustawień uprawnień folderów współdzielonych.

Nadaj użytkownikowi uprawnienia **Read/Write** do odpowiedniego folderu.

## Logowanie przez SSH jako administrator

Połącz się z serwerem QNAP przez SSH, używając konta administratora:

```bash
ssh admin@ADRES_IP_QNAP
```

## Pobranie i uruchomienie skryptu

Pobierz gotowy skrypt z GitHub:

```bash
wget https://raw.githubusercontent.com/dimosska/bash-scripts/refs/heads/main/add-ssh-user.sh
```

Nadaj mu uprawnienia do wykonywania:

```bash
chmod +x add-ssh-user.sh
```

Uruchom skrypt, podając nazwę użytkownika, któremu chcesz nadać dostęp SSH:

```bash
./add-ssh-user.sh nazwa_uzytkownika
```

Skrypt automatycznie dodaje użytkownika do listy `AllowUsers` w plikach:

- `/etc/config/ssh/sshd_config`
- `/etc/config/ssh/sshd_user_config`

## Ponowne uruchomienie usługi SSH przez interfejs WWW

Po wykonaniu skryptu należy zrestartować usługę SSH.

Zaloguj się do interfejsu WWW QTS.

Przejdź do **Panel sterowania → Sieć i usługi plików → Telnet / SSH**.

Wyłącz usługę SSH.

Poczekaj, aż usługa zostanie wyłączona.

Ponownie włącz usługę SSH.

**Ważne:** Restart SSH należy wykonać przez interfejs WWW QTS, poprzez wyłączenie i ponowne włączenie usługi.

## Weryfikacja połączenia

Sprawdź możliwość zalogowania się z nowego konta:

```bash
ssh nazwa_uzytkownika@ADRES_IP_QNAP
```

Po zalogowaniu sprawdź dostęp do folderu oraz możliwość odczytu i zapisu plików zgodnie z nadanymi uprawnieniami.

**Uwaga:** Skrypt nie tworzy użytkowników QNAP ani nie nadaje uprawnień do folderów. Te czynności należy wykonać wcześniej w interfejsie QTS.