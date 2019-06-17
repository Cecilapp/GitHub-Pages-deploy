#!/bin/sh
set -e

USER_NAME="$GITHUB_ACTOR"
# commiter email
if [ -z "$EMAIL" ]
then
  echo "A verified email is required"
  exit 1
fi
USER_EMAIL="EMAIL"
REPOSITORY="$GITHUB_REPOSITORY"
REPONAME="$(echo $GITHUB_REPOSITORY| cut -d'/' -f 2)"
OWNER="$(echo $GITHUB_REPOSITORY| cut -d'/' -f 1)"
GHIO="${OWNER}.github.io"
# target branch
if [[ "$REPONAME" == "$GHIO" ]]; then
  TARGET_BRANCH="master"
else
  TARGET_BRANCH="gh-pages"
fi
# build dir
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
# custom domain?
if [ ! -z "$CNAME" ]
then
  echo "Add custom domain file"
  echo "$CNAME" > CNAME
fi
# .nojekyll
if [ "$JEKYLL_SITE" != "YES" ]
then
  echo "Disable Jekyll"
  touch .nojekyll
fi
git add -Af .
git commit -m "$USER_NAME published a site update"
git push -fq origin $TARGET_BRANCH > /dev/null

echo "### Finished deploy"
