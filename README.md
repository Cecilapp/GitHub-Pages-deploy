# GitHub Pages deploy

> This deploys a static site on GitHub Pages.

![Deploy to GitHub Pages](GitHub-Pages-deploy.png)

![test](https://github.com/Cecilapp/GitHub-Pages-deploy/workflows/test/badge.svg)

## News

Version 3.x.x (`master`) now use the `secrets.GITHUB_TOKEN` instead of a Personal access token, and inputs (`with`) instead of environment variables.

If you want to continue using the previous release (with environment variables) you must set the version: `Cecilapp/GitHub-Pages-deploy@2.0.1`.

## Usage

See [action.yml](action.yml).

```yml
    - name: Deploy to GitHub Pages
      uses: Cecilapp/GitHub-Pages-deploy@3.0.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        email: username@domain.tld
        build_dir: _site
        cname: domain.tld
```

**Workflow example:**

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
      uses: actions/checkout@v2

    - name: Deploy to GitHub Pages
      uses: Cecilapp/GitHub-Pages-deploy@3.0.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        email: arnaud@ligny.org
        build_dir: _site
```

## Note about user and organization sites

> The default publishing source for user and organization sites is the root of the default branch for the repository.

See [documentation](https://docs.github.com/en/free-pro-team@latest/github/working-with-github-pages/about-github-pages#publishing-sources-for-github-pages-sites).

## License

_GitHub Pages deploy_ is a free software distributed under the terms of the MIT license.

© [Arnaud Ligny](https://arnaudligny.fr)
