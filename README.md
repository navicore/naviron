an image for creating Docker containers of a vim-based many-language supporting tmux-centric dev environment

init:

```console
docker run --name naviron -it navicore/naviron
```

re-attach:

```console
docker exec -it naviron tmux attach
```
