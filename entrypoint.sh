#!/bin/sh
set -e

# commiter email
if [ -z "$EMAIL" ]; then
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
if [ -z "$BUILD_DIR" ]; then
  BUILD_DIR="_site"
fi

echo "### Started deploy to $GITHUB_REPOSITORY/$TARGET_BRANCH"

cp -R $BUILD_DIR $HOME/$BUILD_DIR
cd $HOME
git config --global user.name "$GITHUB_ACTOR"
git config --global user.email "$EMAIL"
if [ -z "$(git ls-remote --heads https://${GH_TOKEN}@github.com/${GITHUB_REPOSITORY}.git ${TARGET_BRANCH})" ]; then
  git clone --quiet https://${GH_TOKEN}@github.com/${GITHUB_REPOSITORY}.git $TARGET_BRANCH > /dev/null
  cd $TARGET_BRANCH
  git checkout --orphan $TARGET_BRANCH
  git rm -rf .
  echo "$REPONAME" > README.md
  git add README.md
  git commit -a -m "Create $TARGET_BRANCH branch"
  git push origin $TARGET_BRANCH
  cd ..
else
  git clone --quiet --branch=$TARGET_BRANCH https://${GH_TOKEN}@github.com/${GITHUB_REPOSITORY}.git $TARGET_BRANCH > /dev/null
fi
cp -R $TARGET_BRANCH/.git $HOME/.git
rm -rf $TARGET_BRANCH/*
cp -R $HOME/.git $TARGET_BRANCH/.git
cd $TARGET_BRANCH
cp -Rf $HOME/${BUILD_DIR}/* .
# custom domain?
if [ ! -z "$CNAME" ]; then
  echo "Add custom domain file"
  echo "$CNAME" > CNAME
fi
# .nojekyll
if [ "$JEKYLL_SITE" != "YES" ]; then
  echo "Disable Jekyll"
  touch .nojekyll
fi
# Nothing to deploy?
if [ -z "$(git status --porcelain)" ]; then
  echo "Nothing to deploy"
else
  git add -Af .
  git commit -m "$GITHUB_ACTOR published a site update"
  git push -fq origin $TARGET_BRANCH > /dev/null
fi

echo "### Finished deploy"
