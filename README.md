# Zookeeper (for Kubernetes)

This image is heavily inspired by the [Kubernetes petset example](https://github.com/kubernetes/kubernetes/blob/master/test/e2e/testing-manifests/petset/zookeeper/petset.yaml).

The author opted to take a more static route around container creation, pre-installing the necessary files.

## Whats Happening?

The steps to setup Zookeeper are relatively straightforward.

First, we must query our Zookeeper service to see if there are any
entries for other PetSet pods. Kubernetes allows us to use the annotation
`service.alpha.kubernetes.io/tolerate-unready-endpoints: "true"` on our PetSet
service. This will create DNS `A`-records for each PetSet pod even if the pod
has not yet started. We'll end up with a list of routeable FQDN's.

For a PetSet of size 3, this will look like this.
```
zookeeper-1.zookeeper.default.svc.cluster.local,
zookeeper-2.zookeeper.default.svc.cluster.local,
zookeeper-3.zookeeper.default.svc.cluster.local,
```

We will find the entry that matches our hostname, and write out to a volume our
ordinal id `zookeeper-<id>.zookeeper.default.svc.cluster.local`. This is Zookeepers
`myid` file.

We will then parse through the list of Pets, writing out Zookeeper configurations
for them `server.<id>=<peer>:2888:3888:observer;2181`. If we find our entry, we
set ourselves as a `participant` instead of an `observer`.

From the perspective of `zookeeper-2`, our Zookeeper config file will be:

```
server.1=zookeeper-1.zookeeper.default.svc.cluster.local:2888:3888:observer;2181
server.2=zookeeper-2.zookeeper.default.svc.cluster.local:2888:3888:participant;2181
server.3=zookeeper-3.zookeeper.default.svc.cluster.local:2888:3888:observer;2181
```

Finally, we'll start Zookeeper with this bootstrapping config and fire a cluster
reconfiguration. From the perspective of `zookeeper-2`, this looks like:

``` apacheconf
/opt/zookeeper/bin/zkCli.sh reconfig -add "server.2=zookeeper-2.zookeeper.default.svc.cluster.local:2888:3888:participant;2181"
```

## Usage

`kubectl create -f zookeeper.petset.yaml`

## Note on Volume Provisioners
If you don't have a dynamic volume provisioner running on your Kubernetes cluster, you must remove this annotation and
supply your own persistent volumes.

```
  annotations:
    service.alpha.kubernetes.io/tolerate-unready-endpoints: "true"
```

## Prometheus Exporter

The Kuberentes manfiest also starts a sidecar container making Zookeeper JMX data availible for Prometheus to aggregate.
Feel free to disable that functionality by removing the sidecar