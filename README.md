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
        EMAIL: arnaud@ligny.org               # must be a verified email (required)
        GH_TOKEN: ${{ secrets.ACCESS_TOKEN }} # create it at https://github.com/settings/tokens (required)
        BUILD_DIR: _site                      # build directory ("_site" by default)
        CNAME: narno.com                      # custom domain (optional)
        JEKYLL_SITE: "YES"                    # "YES" in case of a Jekyll site (optional)
```
