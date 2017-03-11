GitHub -> IPFS mirror
---------------------

> GitHub webhook based

### How it works

1. `git push`
2. Webhook throw by GitHub
3. Webhook catch by github-ipfs
4. Clone repository & publish into IPFS
5. Write repository hash into *Registry* at **account**/**repository**/**branch**
6. Publish into IPNS updated *Registry*

### Install

    docker run airalab/github-ipfs -d -p 8080:8000/tcp -e 'REGISTRY_KEY=top_secret'

Docker exports `8080` webhook port set webhook URI in repository `Settings`.

Environment:

* REGISTRY_KEY - GitHub Webhook secret
* REGISTRY_PATH - Absolute registry path in container, default: /registry
* PORT - Webhook port, default: 8000
