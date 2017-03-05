#Checks if Kubectl is installed already, and if not installs it
if ! which kubectl; then
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
fi;

#Update Kubectl - check local version vs stable version from google apis
if [ "$(kubectl version --short --client | awk '{print $3}')" != "$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)" ]; then
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl
    chmod +x ./kubectl

    #Remove old source files to not muck anything up.
    rm -rf /usr/local/bin/kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
fi;
