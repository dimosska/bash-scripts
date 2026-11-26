
#!/bin/sh

# Usage: ./add-ssh-group.sh GROUP_NAME

GROUP="$1"

CONFIG_FILES="
/etc/config/ssh/sshd_user_config
/etc/config/ssh/sshd_config
"

if [ -z "$GROUP" ]; then
    echo "Usage: $0 GROUP_NAME"
    exit 1
fi

if [ "$(id -u)" != "0" ]; then
    echo "Error: Run this script as root."
    exit 1
fi

if ! grep -q "^${GROUP}:" /etc/group; then
    echo "Error: Group '$GROUP' does not exist."
    exit 1
fi

GROUP_USERS=$(grep "^${GROUP}:" /etc/group | cut -d: -f4 | tr ',' ' ')

GID=$(grep "^${GROUP}:" /etc/group | cut -d: -f3)

PRIMARY_USERS=$(awk -F: -v gid="$GID" '$4 == gid {print $1}' /etc/passwd | tr '\n' ' ')

NEW_USERS="$GROUP_USERS $PRIMARY_USERS"

NEW_USERS=$(echo "$NEW_USERS" | tr ' ' '\n' | sort -u | tr '\n' ' ')

if [ -z "$(echo "$NEW_USERS" | tr -d ' ')" ]; then
    echo "No users found in group '$GROUP'."
    exit 1
fi

echo "Group: $GROUP"
echo "Users: $NEW_USERS"

# Update SSH configuration files
for sshconfigfile in $CONFIG_FILES; do

    if [ ! -f "$sshconfigfile" ]; then
        echo "Error: File not found: $sshconfigfile"
        exit 1
    fi

    # Create backup
    cp -p "$sshconfigfile" "${sshconfigfile}.bak"

    # Add users without removing existing ones
    EXISTING_USERS=$(grep "^AllowUsers" "$sshconfigfile" | sed 's/^AllowUsers[[:space:]]*//')

    ALL_USERS="$EXISTING_USERS $NEW_USERS"

    ALL_USERS=$(echo "$ALL_USERS" | tr ' ' '\n' | sort -u | tr '\n' ' ')

    # Update AllowUsers
    if grep -q "^AllowUsers" "$sshconfigfile"; then
        sed -i "s/^AllowUsers.*/AllowUsers $ALL_USERS/" "$sshconfigfile"
    else
        echo "AllowUsers $ALL_USERS" >> "$sshconfigfile"
    fi

    echo "Updated: $sshconfigfile"
done

echo ""
echo "SSH access updated successfully."
echo "Users added: $NEW_USERS"
echo "Backup files created with .bak extension."
