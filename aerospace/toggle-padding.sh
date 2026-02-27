#!/bin/bash
FILE=~/.config/aerospace/aerospace.toml

if grep -q 'outer\.left =       380' "$FILE"; then
    sed -i '' 's/outer\.left =.*/outer.left =       0/' "$FILE"
    sed -i '' 's/outer\.right =.*/outer.right =      0/' "$FILE"
else
    sed -i '' 's/outer\.left =.*/outer.left =       380/' "$FILE"
    sed -i '' 's/outer\.right =.*/outer.right =      380/' "$FILE"
fi

aerospace reload-config
