[![CircleCI](https://circleci.com/gh/cyber-dojo/puller.svg?style=svg)](https://circleci.com/gh/cyber-dojo/puller)

- The source for the [cyberdojo/puller](https://hub.docker.com/r/cyberdojo/puller/tags) Docker image.
- A docker-containerized micro-service for [https://cyber-dojo.org](https://cyber-dojo.org).
- A [Rack](https://github.com/rack/rack) based http server for pulling docker images onto
[cyberdojo/runner](https://github.com/cyber-dojo/runner) nodes.

When [run_cyber_dojo_sh(id,files,manifest)](https://github.com/cyber-dojo/runner/blob/master/docs/api.md#get-run_cyber_dojo_shidfilesmanifest) reaches a `runner` [daemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) [pod](https://kubernetes.io/docs/concepts/workloads/pods/pod/) we want the [language-test-framework](https://github.com/cyber-dojo-languages) image named in `manifest` (eg `cyberdojofoundation/gcc_assert:93eefc6`) to *already* be on the [node](https://kubernetes.io/docs/concepts/architecture/nodes/), otherwise the likely result will be a 'false' timeout if the [docker run](https://docs.docker.com/engine/reference/run/) is allowed (which will implicitly pull the image).

Worse, it will *always* timeout if the image contains a layer that never finishes downloading (eg because it is very large and/or the network is low bandwidth) before the docker-run is stopped. Hence we want the docker image to be on *all* nodes. However, [Kubernetes](https://kubernetes.io/) provides no way to call *all* pods in a daemonSet :(

A long-lived server such as https://cyber-dojo.org can work around this, eg by
making the start-point services daemonSets which pull all images when deployed (typically
the number of new images in a start-point deployment is quite small). However, even for
long-lived servers this approach is not ideal, and it is hopeless for short-lived
servers, which are often on low bandwidth networks. A better approach is to pull a session's
image (eg `cyberdojofoundation/csharp_nunit:1452bb7`) on *all* nodes when a session is created.

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
