FROM ubuntu:22.04

WORKDIR /src

COPY . .

RUN mkdir /root/tools

RUN apt-get update && apt-get install -y jq zip unzip wget build-essential

RUN bash install_miniconda.sh
ENV PATH /root/miniconda3/bin:$PATH
RUN bash install_ansible_miniconda.sh

RUN bash install_docker.sh

RUN bash install_go.sh
ENV GOROOT /root/tools/go
ENV GOPATH /root/go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

RUN bash install_kubectl.sh

RUN bash install_helm.sh
ENV PATH /root/tools/helm:$PATH
RUN helm plugin install https://github.com/chartmuseum/helm-push

RUN bash install_aws_cli.sh

RUN bash install_terraform.sh
ENV PATH /root/tools/terraform:$PATH

RUN bash install_kind.sh

RUN bash install_node.sh
RUN bash config_node_docker.sh
ENV PATH /root/.nvm/versions/node/current/bin:$PATH

RUN bash install_java.sh
ENV PATH /root/.sdkman/candidates/java/current/bin:$PATH
ENV PATH /root/.sdkman/candidates/kotlin/current/bin:$PATH
ENV PATH /root/.sdkman/candidates/gradle/current/bin:$PATH

RUN bash install_linkerd.sh
ENV PATH /root/tools/linkerd:$PATH

RUN bash install_trivy.sh

RUN bash install_istio.sh
ENV PATH /root/tools/istio/bin:$PATH

WORKDIR /
RUN rm -rf /src
