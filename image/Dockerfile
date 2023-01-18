FROM ubuntu:22.04

WORKDIR /src

COPY . .

RUN apt-get update && apt-get install -y jq unzip wget build-essential

RUN bash install_miniconda.sh
ENV PATH /root/miniconda3/bin:$PATH
RUN bash install_ansible_miniconda.sh

RUN bash install_docker.sh

RUN bash install_go.sh
ENV GOPATH /root/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN bash install_kubectl.sh

RUN bash install_helm.sh
RUN helm plugin install https://github.com/chartmuseum/helm-push

RUN bash install_aws_cli.sh

RUN bash install_terraform.sh

RUN bash install_kind.sh

RUN bash install_node.sh
ENV PATH /usr/local/lib/nodejs/node/bin:$PATH

WORKDIR /
RUN rm -rf /src
