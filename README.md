# ansibleforms-helm
This chart installs Ansible Forms, a lightweight GUI for Ansible and AWX

---
## Configuration:
### Secrets
You can either write the application's sensitive data as plain text in `values.yaml` file (e.g. when it's not exposed anywhere), or you can save this data in k8s secret **before** deploying this chart.
The following secrets are optional:
1. **Database credentials** - configure `.Values.mysql.credentials.source` to `secret`, and `.Values.mysql.credentials.secretName` with the secret's name. **Required key:**  
`db_password` - MySQL password for user root
2. **Certificate data** - configure `.Values.expose.tls.certSource` to `secret` and `.Values.expose.tls.secretName`. **Requires keys:**  
`tls.crt` - certificate data only, in pem format  
`tls.key` - certificate's private key

### HTTPS (Context: `Values.expose`)
You can configure whether the application will run in HTTP or HTTPS by setting `$.enable` to `true` or `false` (boolean)

### Expose (context: `.Values.expose`)
Choose how the application will be accessible from outside the cluster. Options are:
1. **Ingress** - expose the application using the `Ingress` resource.  
Configure by setting the `$.type` to `ingress`
**Additional required configuration:** 
 `$.ingress.ingressClassName` - Depends on the IngressController you're using. Check it by running `kubectl get IngressClass`  
 `$.ingress.hostname` - the hostname that will be accessible from outside the cluster (will be typed in the browser's URL). ***If you're running in HTTPS, make sure the hostname matches the CN in your certificate!***
 2. **LoadBalancer** - expose the application by accessing the IP of an external LoadBlanacer. **Your environment must support this resource! (e.g. public clouds)**
3. **NodePort** - expose the application by accessing directly to the cluster's node IP at a port within the range of 30000-32767. 
 *Least recommended*

___
## Installation

### Prerequisites
1. `kubectl` installed
2. `helm` v3
3. Access to a k8s cluster
4. Namespace for Ansible Forms to run in (pre-created)
5. *If using secrets* - secrets with desired data  

### Deploying the chart

clone repository and descend into it's directory

````bash
git clone <repository URL>
cd ansibleforms-helm
````

Install chart in the desired namespace
```bash
helm install ansibleforms-helm --namespace <namespace>
```
The application will now be deployed in your namespace and 2 pods with 1 container each (`server` and `mysql`) are started.
When both pods are running, one can access the web interface as a dependency of how you chose to expose it:
1. **Ingress** - Ansible Forms will be accessible in `http(s)://.Values.expose.ingress.hostname`
2. **LoadBalancer** - check it's external IP by running `kubectl get svc server -o wide`. Access Ansible Forms in `http(s)://<LoadBalancer external port>
3. **NodePort** - check what port was assigned to the service by running `kubectl get svc server -o wide`. Ansible Forms will be accessible in any of your worker node's IPs in this port. `http(s)://<worker IP>:<node port>`

---
## How it works?
First request in web interface leads the application to install necessary DB and appropriate tables. User ```admin``` with password ```AnsibleForms!123``` is created and the web interface is redirecting to the login page.
Before login a minmal set of config files have to be added to the application first. To do so run 
```
POD=$(kubectl get pod -l app.kubernetes.io/name=server -n ansibleforms -o jsonpath="{.items[0].metadata.name}")
kubectl cp data/forms.yaml ansibleforms/$POD:/app/dist/persistent/
kubectl cp data/playbooks ansibleforms/$POD:/app/dist/persistent/
```
Main config file ```data/forms.yaml``` is copied to persistent storage as well as all files in the ```playbooks``` folder, containing some default Ansible playbooks. ```forms.yaml``` is being modified through the app itself, for adding custom Ansible playbooks the same way as above can be used.