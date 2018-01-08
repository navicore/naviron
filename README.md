[![Build Status](https://travis-ci.org/navicore/naviron.svg?branch=master)](https://travis-ci.org/navicore/naviron)

an image for creating Docker containers of a vim-based many-language supporting tmux-centric dev environment

default tmux:

```console
docker run --name naviron -it navicore/naviron
 or with local files
docker run -v /Users/navicore/.ssh:/home/navicore/.ssh -v /Users/navicore/git:/home/navicore/git --name naviron -it navicore/naviron
```

sh:

```console
docker run -it --entrypoint=sh navicore/naviron -s
```

re-attach:

```console
docker exec -it naviron tmux attach
```

kubernetes deployment

```console
kubectl run naviron --rm -i --tty --image navicore/naviron
```

kubernetes re-attach

```console
kubectl attach naviron-<POD ID> -c naviron -i -t
```

