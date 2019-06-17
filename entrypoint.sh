#!/bin/sh
set -e

# commiter email
if [ -z "$EMAIL" ]
then
  echo "A verified email is required"
  exit 1
fi
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
if [ -z "$BUILD_DIR" ]
then
  BUILD_DIR="_site"
fi

echo "### Started deploy to $GITHUB_REPOSITORY/$TARGET_BRANCH"

cp -R $BUILD_DIR $HOME/$BUILD_DIR
cd $HOME
git config --global user.name "$GITHUB_ACTOR"
git config --global user.email "$EMAIL"
git clone --quiet --branch=$TARGET_BRANCH https://${GH_TOKEN}@github.com/${GITHUB_REPOSITORY}.git $TARGET_BRANCH > /dev/null
cp -R gh-pages/.git $HOME/.git
rm -rf gh-pages/*
cp -R $HOME/.git gh-pages/.git
cd gh-pages
cp -Rf $HOME/${BUILD_DIR}/* .
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
git commit -m "$GITHUB_ACTOR published a site update"
git push -fq origin $TARGET_BRANCH > /dev/null

echo "### Finished deploy"
