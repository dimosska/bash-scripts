# Instrukcja – dodawanie użytkowników grupy do SSH na QNAP

## 1. Opis

Skrypt `add-ssh-group.sh` służy do automatycznego dodawania wszystkich użytkowników należących do wskazanej grupy systemowej do listy użytkowników uprawnionych do korzystania z SSH na serwerze QNAP.

Skrypt modyfikuje dwa pliki konfiguracyjne SSH:

- `/etc/config/ssh/sshd_config`
- `/etc/config/ssh/sshd_user_config`

Przed każdą modyfikacją tworzy kopię zapasową pliku z rozszerzeniem `.bak`.

## 2. Pobranie skryptu

Zaloguj się do QNAP przez SSH jako użytkownik z uprawnieniami administratora.

Pobierz skrypt za pomocą `wget`:

```bash
wget -O add-ssh-group.sh https://raw.githubusercontent.com/dimosska/bash-scripts/refs/heads/main/add-ssh-group/add-ssh-group.sh
```

Nadaj skryptowi uprawnienia do wykonywania:

```bash
chmod +x add-ssh-group.sh
```

## 3. Uruchomienie skryptu

Skrypt przyjmuje nazwę grupy jako argument.

Przykład – dodanie wszystkich użytkowników z grupy `backup`:

```bash
./add-ssh-group.sh backup
```

## 4. Działanie skryptu

Podczas wykonywania skrypt:

1. Sprawdza, czy podana grupa istnieje w systemie.
2. Pobiera listę użytkowników należących do grupy.
3. Uwzględnia zarówno użytkowników przypisanych do grupy dodatkowej, jak i użytkowników, dla których jest to grupa podstawowa.
4. Usuwa powtarzające się nazwy użytkowników.
5. Odczytuje aktualną listę `AllowUsers`.
6. Dodaje nowych użytkowników, zachowując dotychczasowe wpisy.
7. Tworzy kopie zapasowe plików konfiguracyjnych.
8. Aktualizuje konfigurację SSH w obu plikach.

## 5. Weryfikacja konfiguracji

Po wykonaniu skryptu można sprawdzić aktualną listę użytkowników uprawnionych do korzystania z SSH:

```bash
grep -n "^AllowUsers" \
/etc/config/ssh/sshd_config \
/etc/config/ssh/sshd_user_config
```

## 6. Kopie zapasowe

Przed każdą modyfikacją tworzone są kopie zapasowe:

```text
/etc/config/ssh/sshd_config.bak
/etc/config/ssh/sshd_user_config.bak
```

W przypadku potrzeby przywrócenia poprzedniej konfiguracji można odtworzyć pliki z kopii zapasowych.

**Uwaga:** Skrypt modyfikuje wyłącznie uprawnienia dostępu SSH. Nie tworzy użytkowników ani nie przypisuje ich do grup systemowych.
