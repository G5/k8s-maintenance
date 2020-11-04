## Kubernetes Maintenance Page

This is a simple maintenance container, which responds to request at any URL with a maintenance announcement. It is available on G5's (non-public) Google Container Registry at `gcr.io/g5-images/maintenance-page`.

This is really intended to run in Kubernetes, using the provided sample Deployment in `deployment.yaml`.

### Swapping in a maintenance page

The intention here is that a K8s service pointed at an app can be re-pointed with selectors to a pod running the maintenance page when the app is undergoing maintenance. That's it.

K8s exhibits some funky behavior when you attempt to `kubectl apply` a modified service definition (it merges the labels instead of replaces them). You can use `kubectl replace`, but that only works with the absolutely latest revision of the service definition. This behavior seems undefined, though, and could have *dire consequences for a load balancer* if the service is torn down while this happens.

As far as I can tell, you can't just check in two service definitions, one for normal behavior and one for maintenance mode, and reliably apply one or the other.  The safest/sketchiest way to bring up a maintenance page is to either `kubectl get svc/myservicename -O yaml" and edit it, or just `kubectl edit`. I say sketchy, because if you misspell a selector, your site is now down.
