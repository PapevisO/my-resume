#!/bin/sh

# Fetch environment variables or set to default empty values
MOUNTPOINT_NAMESPACE=${MOUNTPOINT_NAMESPACE:-}
MOUNTPOINT=${MOUNTPOINT:-}

# Determine the mount point based on environment variables
# 1. If MOUNTPOINT is unset but MOUNTPOINT_NAMESPACE is set
if [ -z "$MOUNTPOINT" ] && [ -n "$MOUNTPOINT_NAMESPACE" ]; then
    MOUNTPOINT="/$MOUNTPOINT_NAMESPACE/$THEME_VALUE"
# 2. If both MOUNTPOINT and MOUNTPOINT_NAMESPACE are unset
elif [ -z "$MOUNTPOINT" ] && [ -z "$MOUNTPOINT_NAMESPACE" ]; then
    MOUNTPOINT="/$THEME_VALUE"
# 3. If MOUNTPOINT is set, it takes precedence and MOUNTPOINT_NAMESPACE is disregarded
fi

# Check if resume.json has a valid date and if PDF rebuild is required
PDF_PATH="$MOUNTPOINT/resume.pdf"
JSON_PATH="$MOUNTPOINT/resume.json"


# Get the current date and the last modification date of resume.json
CURRENT_DATE=$(date +%s)
JSON_DATE=$(date -d $(stat -c %y "$JSON_PATH" 2>/dev/null) +%s 2>/dev/null)

# If resume.json's date is in the future
if [ $JSON_DATE -gt $CURRENT_DATE ]; then
    DAYS_DIFFERENCE=$(( (JSON_DATE - CURRENT_DATE) / 86400 )) # Convert seconds difference to days
    echo "Warning: The date of resume.json ($(date -d @$JSON_DATE)) is $DAYS_DIFFERENCE days ahead of the current date ($(date -d @$CURRENT_DATE)). Not processing."
else
    # Rebuild PDF if it's missing or if resume.json is newer than resume.pdf
    if [ ! -f "$PDF_PATH" ] || [ "$JSON_PATH" -nt "$PDF_PATH" ]; then
        # Add the logic/command to rebuild the PDF here
        echo "Rebuilding PDF..."
    fi
fi

# Run the node command with the determined directory
node \
    /usr/app/node_modules/resume-cli/build/main.js \
    serve \
    --theme $THEME_VALUE \
    --silent \
    --dir $MOUNTPOINT
