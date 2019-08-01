FROM alpine/git:latest

LABEL "com.github.actions.name"="GitHub Pages deploy"
LABEL "com.github.actions.description"="A GitHub Action to deploy a static site on GitHub Pages."
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="black"

LABEL "repository"="https://github.com/Cecilapp/GitHub-Pages-deploy"
LABEL "homepage"="https://github.com/Cecilapp/GitHub-Pages-deploy"
LABEL "maintainer"="Arnaud Ligny <arnaud+github@ligny.fr>"

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
