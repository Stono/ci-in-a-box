# ci-in-a-box
![Logo](images/logo.png)

Welcome to __ci in a box__!

## What is this?
An open sourced version of the continuous integration and delivery setup I use on a daily basis.  Essentially a command line interface for automating a bunch of _low value work_.  It will:

  - Reserve three static ips, gocd, preprod and prod
  - Create a named network
  - Deploy two subnetworks:
    - preprod: `10.37.64.0/19`
    - prod: `10.35.96.0/19`
  - Deploy a preprod kubernetes cluster, HA'd across eu-west1-c and eu-west1-d into the preprod subnet
  - Deploy a prod kuberneters cluster in the same way, to the prod subnet
  - Provising some persistent storage for GoCD server
  - Deploy GoCD Master (in docker), fronted with SSL (LetsEncrypt) via Nginx
  - Deploy Special GCP tweaked GoCD Agents (also in docker, and scalable) for the preprod and prod environments
  - Make you a cup of tea.

... Just kidding about the last one, it won't make you a brew.  But with all this free time on your hands, you can totally make your own!

## But why?
Are you once of those people that spends the first few weeks of any new engagement setting up your infrastructure (ips, firewalls, networking), Kubernetes, then installing your CI server (in my case, GoCD)?  I want to be able to kick off a docker/kubernetes/gcp project with the least amount of effort.

## Awesome, so what do I do?

  1. Clone the repo
  2. Create an `.env` file in the root of the directory
  3. Run `./start`

### An env file?
Yes, this is a completely generic implementation that is configured with the env file.  It should look like, and have all the following properties:

```
# Behaviour
NO_PROMPT="true"   # Dont prompt for confirmation of variables
NO_CONFIRM="false" # Dont prompt to continue

GCP_PROJECT_NAME="your-gcp-project-name"
STACK_NAME="testing"
STATE_BUCKET="$STACK_NAME-terraform"

# Kubernetes stuff
CLUSTER_PASSWORD="cluster-password"
NETWORK_NAME="$STACK_NAME-poc-network"

# Application Stuff
LETSENCRYPT_EMAIL="testing@test.com"
GOCD_USERNAME="user-name"
GOCD_PASSWORD="password"
GOCD_AGENT_KEY="some-super-secure-agent-key"

```

### Running `./start`
The script will validate you have all the required bits and bobs, and if you don't - prompt you what to go.  My intention is to move this entire script into its own docker container soon too, so you wont need these dependencies on your host.  Plus, I built this on Linux, it probably won't work on Mac or Windows.

```
$ ./start 
Checking tool dependencies...
 + kubectl
 + terraform
 + gcloud
 + gsutil
 + git
 + gpg2
 + curl
 + pdata

Checking tool versions...
 + kubectl (1.5.3 >= 1.5.3)
 + terraform (0.8.7 >= 0.8.7)
 + gcloud sdk (146.0.0 >= 146.0.0)

Checking environment configuration...
 + Lets Encrypt email address (testing@test.com): 
 + This application stack name (testing): 
 + GCS Bucket to store state in (testing-terraform): 
 + GCP Private Network Name (testing-poc-network): 
 + GCP Project Name (your-gcp-project-name): 
 + The Kubernetes cluster password (testingpassword): 
 + Username to login to GOCD with (test-user): 
 + Password to login to GOCD with (password): 
 + Secure key that agents connect with (testingtesting): 

Setting cloud project...
Updated property [core/project].

 + Setup Complete!

Welcome to the all in one GCP EU Kubernetes deployment script.

Usage: start <command>
 - build      [preprod | prod | networking]  Plan and Build one of these
 - destroy    [preprod | prod | networking]  Destroy one of these
 - configure  [preprod | prod]               Configure one of these
 - deploy     [gocd-master | gocd-agents]    Deploy either the go master or agents

 - bootstrap                                 Does all of the above, on a new GCP project
 - nuke                                      Destroy everything in one devastating blow
```
