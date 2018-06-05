# AWS ECR creds for Flux

This container provides a way to get the ECR creds via aws-cli and then login via Docker and write the Docker .config file to disk somewhere.

## Basic usage

1. Replace "ap-southeast-2" in `flux-deployment.yaml` with the name of the AWS region that your registry is in
1. Edit the "--git-url" in `flux-deployment.yaml` to point to your git repository
1. Install the supporting manifests from [weaveworks/flux/deploy](https://github.com/weaveworks/flux/tree/master/deploy) according to the [installation instructions](https://github.com/weaveworks/flux/blob/a83ef890fc77f1fac9a3b0a59c811ef4c6a6a113/site/standalone/installing.md)
1. Install the `flux-deployment.yaml` manifest with `kubectl apply -f flux-deployment.yaml`

Now your flux pod should be up and running and checking ECR images running inside your cluster!

If you see an error message about "--docker-config" then something isn't configured right. Debug by running `kubectl exec -it <pod_name> -c flux /bin/sh` and running `cat /docker-creds/config.json` and inspecting the docker config using `base64` to look for reasons why.

The Dockerfile is provided for convenience but the one already used in the manifest should work fine.

## Multiple docker registry support

You can also get support for ECR in combination with other docker registries. To do this, edit the `flux-with-secrets-deployment.yaml` file as you would for the basic usage, change the references to `example-docker-pull-secret` to instead point to a secret in the namespace flux is running in. The secret should be of type `kubernetes.io/dockercfg`. Anything created for use with a serviceAccount will work.

Apply the `flux-with-secrets-deployment.yaml` manifest and it will use jq to combine all of the docker auth json together into one file, which flux will then use for auth.
