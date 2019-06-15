# GHPages deploy Action

A GitHub Action to deploy to GitHub Pages.

## Usage

```hcl
action "Deploy to GitHub Pages" {
  uses = "Cecilapp/GHPages-deploy-Action@master"
  env = {
    BUILD_DIR = "_site/"
    CNAME = narno.com
  }
  secrets = ["GITHUB_TOKEN"]
}
```
