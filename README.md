# GitHub Pages deploy

This Action deploys a static site on GitHub Pages.

[![test](https://github.com/Cecilapp/GitHub-Pages-deploy/actions/workflows/test.yml/badge.svg)](https://github.com/Cecilapp/GitHub-Pages-deploy/actions/workflows/test.yml)

## Usage

See [action.yml](action.yml).

```yml
- name: Deploy to GitHub Pages
  uses: Cecilapp/GitHub-Pages-deploy@v3
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  with:
    email: username@domain.tld
    build_dir: _site               # optional
    branch: website                # optional
    cname: domain.tld              # optional
    jekyll: no                     # optional
    commit_message: custom message # optional
```

### Workflow example

```yml
name: GitHub Pages deploy
on:
  push:
    branches:
      - master

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Build
        uses: # build your static site

      - name: Deploy to GitHub Pages
        uses: Cecilapp/GitHub-Pages-deploy@v3
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          email: username@domain.tld
          build_dir: _site
```

## About _user_ and _organization_ sites

> The default publishing source for user and organization sites is the root of the default branch for the repository.

See [documentation](https://docs.github.com/en/free-pro-team@latest/github/working-with-github-pages/about-github-pages#publishing-sources-for-github-pages-sites).

### v2 VS v3

> _GitHub Pages deploy_ v3 use the [`secrets.GITHUB_TOKEN`](https://docs.github.com/en/free-pro-team@latest/actions/reference/authentication-in-a-workflow) instead of a [personal access token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) (PAT), and [inputs parameters](https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepswith) instead of environment variables.
> If you want to continue using the previous release (with environment variables) you must set the version: [`Cecilapp/GitHub-Pages-deploy@v2`](https://github.com/marketplace/actions/gh-pages-deploy?version=2.0.1).

## License

_GitHub Pages deploy_ is a free software distributed under the terms of the MIT license.

© [Arnaud Ligny](https://arnaudligny.fr)
