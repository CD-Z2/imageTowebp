#!/bin/bash

SOURCE_DIR="${1:-.}"
OUTPUT_DIR="${2:-webp_output}"

QUALITY=85

mkdir -p "$OUTPUT_DIR"
TEMP_FILE=$(mktemp)
find "$SOURCE_DIR" -type f -print0 > "$TEMP_FILE"

export QUALITY OUTPUT_DIR SOURCE_DIR

cat "$TEMP_FILE" | parallel --null --jobs "$(nproc)" --will-cite --bar '
    FILE={}
    RELATIVE_PATH=$(dirname "${FILE#$SOURCE_DIR/}")
    BASENAME=$(basename "$FILE")
    OUTPUT_SUBDIR="$OUTPUT_DIR/$RELATIVE_PATH"
    mkdir -p "$OUTPUT_SUBDIR"

    if [[ "$FILE" =~ \.(jpg|jpeg|png)$ ]]; then
        OUTPUT_FILE="$OUTPUT_SUBDIR/$BASENAME.webp"
        
        if [ -f "$OUTPUT_FILE" ]; then
            echo "Skipping (already converted): $FILE"
            exit 0
        fi

        ffmpeg -i "$FILE" -q:v $QUALITY -loglevel error "$OUTPUT_FILE" || echo "Error converting: $FILE" >&2
    else
        cp "$FILE" "$OUTPUT_SUBDIR/$BASENAME" || echo "Error copying: $FILE" >&2
        echo "Copied: $FILE -> $OUTPUT_SUBDIR/$BASENAME"
    fi
'

rm -f "$TEMP_FILE"
