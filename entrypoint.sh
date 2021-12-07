#!/bin/sh
set -e

# Which branch?
REPONAME="$(echo $GITHUB_REPOSITORY| cut -d'/' -f 2)"
OWNER="$(echo $GITHUB_REPOSITORY| cut -d'/' -f 1)"
GHIO="${OWNER}.github.io"
if [[ "$REPONAME" == "$GHIO" ]]; then
  TARGET_BRANCH="master"
else
  TARGET_BRANCH="gh-pages"
fi
# Custom branch
if [ ! -z "$INPUT_BRANCH" ]; then
  TARGET_BRANCH=$INPUT_BRANCH
fi

echo "Starting deploy to $GITHUB_REPOSITORY/$TARGET_BRANCH"

echo "Configuration:"
echo "- email: $INPUT_EMAIL"
echo "- build_dir: $INPUT_BUILD_DIR"
echo "- cname: $INPUT_CNAME"
echo "- Jekyll: $INPUT_JEKYLL"

# Prepare build_dir
BUILD_DIR=$INPUT_BUILD_DIR
BUILD_DIR=${BUILD_DIR%/} # remove the ending slash if exists
mkdir -p $HOME/build/$BUILD_DIR
cp -R $BUILD_DIR/* $HOME/build/$BUILD_DIR/

# Create or clone the gh-pages repo
mkdir -p $HOME/branch/
cd $HOME/branch/
git config --global user.name "$GITHUB_ACTOR"
git config --global user.email "$INPUT_EMAIL"
if [ -z "$(git ls-remote --heads https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git ${TARGET_BRANCH})" ]; then
  echo "Create branch '${TARGET_BRANCH}'"
  git clone --quiet https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git $TARGET_BRANCH > /dev/null
  cd $TARGET_BRANCH
  git checkout --orphan $TARGET_BRANCH
  git rm -rf .
  echo "$REPONAME" > README.md
  git add README.md
  git commit -a -m "Create '$TARGET_BRANCH' branch"
  git push origin $TARGET_BRANCH
  cd ..
else
  echo "Clone branch '${TARGET_BRANCH}'"
  git clone --quiet --branch=$TARGET_BRANCH https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git $TARGET_BRANCH > /dev/null
fi

# Sync repository with build_dir
cp -R $TARGET_BRANCH/.git $HOME/build/$BUILD_DIR/.git
rm -rf $TARGET_BRANCH/*
cp -R $HOME/build/$BUILD_DIR/.git $TARGET_BRANCH/.git
# Copy files
cd $TARGET_BRANCH
cp -Rf $HOME/build/$BUILD_DIR/* .

# Custom domain
if [ ! -z "$INPUT_CNAME" ]; then
  echo "$INPUT_CNAME" > CNAME
fi

# Custom commit message
if [ -z "$INPUT_COMMIT_MESSAGE" ]
then
  INPUT_COMMIT_MESSAGE="$GITHUB_ACTOR published a site update"
fi

# .nojekyll
if [ "$INPUT_JEKYLL" != "yes" ]; then
  touch .nojekyll
fi

# Deploy/Push (or not?)
if [ -z "$(git status --porcelain)" ]; then
  result="Nothing to deploy"
else
  git add -Af .
  git commit -m "$INPUT_COMMIT_MESSAGE"
  git push -fq origin $TARGET_BRANCH > /dev/null
  # push is OK?
  if [ $? = 0 ]
  then
    result="Deploy succeeded"
  else
    result="Deploy failed"
  fi
fi

# Set output
echo $result
echo "::set-output name=result::$result"
