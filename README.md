## Prepare Raspberry PI for K3S ##

1) Download a 64 bit version of Raspberry PI OS. It's still in beta stage, but can be downloaded here: https://downloads.raspberrypi.org/raspios_arm64/images/

(Ubuntu 64 bit version might work too but I haven't tested)

2) Use Raspberry PI Imager to store it in SD disk 
3) Turn on Raspberry PI and do the basic setup for network and enable SSH

## Install K3S ## 

1) SSH to your new Raspberry PI and edit cmdline.txt: 

```bash
 sudo nano /boot/cmdline.txt and add "cgroup_memory=1 cgroup_enable=memory" at the end of line. 
```
It should be something like below:

```bash
pi@raspberrypi:~ $ sudo cat /boot/cmdline.txt
console=serial0,115200 console=tty1 root=PARTUUID=bbaafdf6-02 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait cgroup_memory=1 cgroup_enable=memory
```

2) Install K3S 
```
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
```
Note: The flag **--write-kubeconfig-mode 644** allows you to run kubectl commands without 'sudo'

3) Validate that K3S is up and running 
```bash
kubectl get nodes
```

## Import the K3S cluster to Rancher

1) Go to your rancher installation and press "Add Cluster" 

2) Rancher gives an URL with Kubernetes deployments manifests -> Download that to your local computer 

3) Modify the manifest, set rancher-agent to linux-arm64 version

rancher/rancher-agent:v2.5.1-linux-arm64

4) Apply the manifest with kubectl apply -f rancher.yml

=> Your Raspberry PI should be imported. 




