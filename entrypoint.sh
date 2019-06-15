#!/bin/sh

set -e

USER_NAME="$GITHUB_ACTOR"
USER_EMAIL="$GITHUB_ACTOR@users.noreply.github.com"
REPOSITORY="$GITHUB_REPOSITORY"
REPONAME="$(echo $GITHUB_REPOSITORY| cut -d'/' -f 2)"
OWNER="$(echo $GITHUB_REPOSITORY| cut -d'/' -f 1)"
GHIO="${OWNER}.github.io"
if [[ "$REPONAME" == "$GHIO" ]]; then
  TARGET_BRANCH="master"
else
  TARGET_BRANCH="gh-pages"
fi
if [ -z "$SITE_DIR" ]
then
    SITE_DIR="_site"
fi

echo "### Started deploy to $REPOSITORY/$TARGET_BRANCH"

cp -R $SITE_DIR $HOME/$SITE_DIR
cd $HOME
git config --global user.name "$USER_NAME"
git config --global user.email "$USER_EMAIL"
git clone --quiet --branch=$TARGET_BRANCH https://${GITHUB_TOKEN}@github.com/${REPOSITORY}.git $TARGET_BRANCH > /dev/null
cp -R gh-pages/.git $HOME/.git
rm -rf gh-pages/*
cp -R $HOME/.git gh-pages/.git
cd gh-pages
cp -Rf $HOME/$SITE_DIR/* .
if [ ! -z "$CNAME" ]
then
    echo "$CNAME" > CNAME
fi
git add -Af .
git commit -m "$USER_NAME push updated website"
git push -fq origin $TARGET_BRANCH > /dev/null

echo "### Finished deploy"
