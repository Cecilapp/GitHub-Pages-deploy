# GitHub Pages deploy

A GitHub Action to deploy a static site on GitHub Pages.

![Deploy to GitHub Pages](GitHub-Pages-deploy.gif)

## Usage

```yml
name: GitHub Pages deploy
on:
  push:
    branches:
      - master
jobs:
  checkout-and-deploy:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@master
    - name: Deploy to GitHub Pages
      uses: Cecilapp/GitHub-Pages-deploy@master
      env:
        EMAIL: arnaud@ligny.org               # must be a verified email
        GH_TOKEN: ${{ secrets.ACCESS_TOKEN }} # https://github.com/settings/tokens
        BUILD_DIR: _site/                     # "_site/" by default
        CNAME: narno.com                      # in case of custom domain
        JEKYLL_SITE: "YES"                    # only in case of a Jekyll site
```
