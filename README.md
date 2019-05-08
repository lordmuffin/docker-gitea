# docker-gitea

Run with a command like this:
`docker run -it -p 3000:3000 --mount type=bind,source="/Users/ajackson/tmp/gitea",target="/data" --mount type=bind,source="/Users/ajackson/Google Drive/gitea/backups",target=/data/backups --rm gitea:latest`