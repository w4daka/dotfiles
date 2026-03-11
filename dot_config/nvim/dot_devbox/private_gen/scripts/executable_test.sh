set -e

if [ -z "$__DEVBOX_SKIP_INIT_HOOK_b64abef24954579f238b9d6a9e8c13c8bb3c9ce3ff580080e9bf36885e9ddbae" ]; then
    . "/home/w4dkaka/.config/nvim/.devbox/gen/scripts/.hooks.sh"
fi

echo "Error: no test specified" && exit 1
