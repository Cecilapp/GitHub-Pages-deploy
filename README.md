# GitHub Pages deploy

> This deploys a static site on GitHub Pages.

![Deploy to GitHub Pages](GitHub-Pages-deploy.png)

![test](https://github.com/Cecilapp/GitHub-Pages-deploy/workflows/test/badge.svg)

## Usage

See [action.yml](action.yml).

```yml
    steps:
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

## License

_GitHub Pages deploy_ is a free software distributed under the terms of the MIT license.

© [Arnaud Ligny](https://arnaudligny.fr)
