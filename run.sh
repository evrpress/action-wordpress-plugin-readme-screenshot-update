#!/bin/bash

# Note that this does not use pipefail
# because if the grep later doesn't match any deleted files,
# which is likely the majority case,
# it does not exit with a 0, and I only care about the final exit.
set -eo

php /home/runner/work/_actions/evrpress/action-wordpress-plugin-readme-screenshot-update/main/convert.php

git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

#git add README.md
#git commit -m "Updated Readme"
git remote set-url origin "https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
#git push origin --force -all

git diff-index --quiet HEAD || (git commit -a -m'Updated Readme' --allow-empty && git push origin -f)

echo "✓ Readme Converted!"
