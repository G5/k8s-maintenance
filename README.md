## Kubernetes Maintenance Page

This is a simple maintenance container, which responds to request at any URL with and without SSL with a maintenance announcement. It is available on the Docker Hub at [`g5search/k8s-maintenance`](https://hub.docker.com/r/g5search/k8s-maintenance/).

To run the container with plain Docker, a cert and key files must be volume mounted in at `/etc/ssl/secrets/proxycert` and `/etc/ssl/secrets/proxykey`. This is really intended to run in Kubernetes, using your own modified version of the provided sample Deployment in `deployment.yaml`. Those filenames are specifically using the same secret layout as Google's [nginx-ssl-proxy](https://github.com/GoogleCloudPlatform/nginx-ssl-proxy) image.

### Swapping in a maintenance page

The intention here is that a K8s service pointed at an app using the `nginx-ssl-proxy` image can be re-pointed with selectors to a pod running the maintenance page when the app is undergoing maintenance. That's it.

K8s exhibits some funky behavior when you attempt to `kubectl apply` a modified service definition (it merges the labels instead of replaces them). You can use `kubectl replace`, but that only works with the absolutely latest revision of the service definition. As far as I can tell, you can't just check in two service definitions, one for normal behavior and one for maintenance mode, and reliably apply one or the other. You might be able to do this with `kubectl replace`, but that might have *dire consequences if you have a load balancer*! The behavior seems undefined.

Bottom line, the safest/sketchiest way to bring up a maintenance page is to either `kubectl get svc/myservicename -O yaml" and edit it, or just `kubectl edit`. I say sketchy, because if you misspell a selector, your site is down.
