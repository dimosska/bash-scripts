
#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 username"
    exit 1
fi

USER="$1"

FILES=(
    "/etc/config/ssh/sshd_config"
    "/etc/config/ssh/sshd_user_config"
)

for FILE in "${FILES[@]}"; do
    if [ ! -f "$FILE" ]; then
        echo "File not found: $FILE"
        continue
    fi

    if grep -q "^AllowUsers" "$FILE"; then
        if grep -qE "^AllowUsers.*(^| )${USER}( |$)" "$FILE"; then
            echo "User $USER already exists in $FILE"
        else
            cp -p "$FILE" "$FILE.bak" || {
                echo "Backup failed: $FILE"
                continue
            }

            sed -i "/^AllowUsers/s/$/ $USER/" "$FILE"
            echo "Added $USER to $FILE (backup: $FILE.bak)"
        fi
    else
        echo "AllowUsers directive not found in $FILE"
    fi
done

echo "Done."
