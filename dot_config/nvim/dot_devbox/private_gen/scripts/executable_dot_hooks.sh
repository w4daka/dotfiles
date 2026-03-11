test -z $DEVBOX_COREPACK_ENABLED || corepack enable --install-directory "/home/w4dkaka/.config/nvim/.devbox/virtenv/nodejs_20/corepack-bin/"
test -z $DEVBOX_COREPACK_ENABLED || export PATH="/home/w4dkaka/.config/nvim/.devbox/virtenv/nodejs_20/corepack-bin/:$PATH"
echo 'Welcome to devbox!' > /dev/null