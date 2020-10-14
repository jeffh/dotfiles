#!/usr/bin/env sh

NIX_PROFILE="$HOME"/.nix-profile
APP_DIR=/Applications

# remove broken links
for f in "$APP_DIR"/*; do
    if [ -L "$f" ] && [ ! -e "$f" ]; then
        echo "$f"
        rm "Clearing $f"
    fi
done

# link new ones
for f in "$NIX_PROFILE"/Applications/*; do
    app_name="$(basename "$f")"
    if [ ! -e "$APP_DIR/$app_name" ]; then
        echo "Linking $app_name"
        # ln -s "$f" "$APP_DIR"/
        cp -r "$f" "$APP_DIR/$app_name"
    else
        echo "Existing $app_name, skipping."
    fi
done
