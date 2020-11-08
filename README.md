# Container Web Terminal

This project is forked from [bitbull-team's docker-exec-web-console repo](https://github.com/bitbull-team/docker-exec-web-console) which is originally inspirated by [this gist](https://gist.github.com/Humerus/0268c62f359f7ee1ee2d).

You can launch the container in this way:

```
docker run \
	--name container-web-console \
	-p 9999:8888 \
	-v /var/run/docker.sock:/var/run/docker.sock \
	quay.io/enterprisecoding/container-web-console
```

Then you can reach the console at the url `http://localhost:9999`

It's possible to pass a context path to which the container will responds, using `CONTEXT_PATH` environment variable:

```
docker run \
	--name container-web-console \
	-p 9999:8888 \
	-e "CONTEXT_PATH=/webconsole" \
	-v /var/run/docker.sock:/var/run/docker.sock \
	quay.io/enterprisecoding/container-web-console
```

With the above example, the console will be reachable at the url `http://localhost:9999/webconsole`

You can select the container to exec into passing its id directly via `cid` querystring parameter ( eg. `http://localhost:9999?cid=<container id>` ) or in the prompt that will show at page load.

You can pass the command to execute passing it via `cmd` querystring parameter ( eg. `http://localhost:9999?cid=<container id>&cmd=/bin/sh` ), otherwise it default to `/bin/bash`.

## Build the image

The image is designed to have a multi-stage docker file. Base container ise build on `alpine:latest` and compiler part uses `golang:1.15.4-alpine`. All you have to do is build container image using following command;

```
docker build -t quay.io/enterprisecoding/container-web-console .
```
