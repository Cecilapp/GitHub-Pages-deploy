# GitHub Pages deploy

A GitHub Action to deploy a static site on GitHub Pages.

![Deploy to GitHub Pages](GitHub-Pages-deploy.gif)

## Usage

```hcl
action "Deploy to GitHub Pages" {
  uses = "Cecilapp/GitHub-Pages-deploy@master"
  env = {
    BUILD_DIR = "_site/"       # "_site/" by default
    CNAME = "narno.com"        # in case of custom domain
    EMAIL = "arnaud@ligny.org" # must be a verifed email
    JEKYLL_SITE = "YES"        # only in case of a Jekyll site
  }
  secrets = ["GH_TOKEN"]       # https://github.com/settings/tokens
}
```
