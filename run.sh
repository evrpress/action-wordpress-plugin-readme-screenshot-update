#!/bin/bash

# Note that this does not use pipefail
# because if the grep later doesn't match any deleted files,
# which is likely the majority case,
# it does not exit with a 0, and I only care about the final exit.
set -eo

FILEHASH=$(sha1sum README.md)

php "${GITHUB_ACTION_PATH}/convert.php"

NEWFILEHASH=$(sha1sum README.md)

if [ "$FILEHASH" == "$NEWFILEHASH" ]; then
    echo "✓ Readme not changed, exiting"
    exit 0
fi

git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

#git add README.md
#git commit -m "Updated Readme"
git remote set-url origin "https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
#git push origin --force -all

git diff-index --quiet HEAD || (git commit -a -m 'Updated Readme' --allow-empty && git push origin -f)

echo "✓ Readme Converted!"
