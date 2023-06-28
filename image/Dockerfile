FROM ubuntu:22.04

RUN groupadd clouddev && useradd --no-log-init -m -s /bin/bash -g clouddev clouddev

USER clouddev

WORKDIR /home/clouddev/src

COPY . .

USER root

RUN apt-get update && apt-get install -y jq zip unzip wget build-essential

RUN bash install_docker.sh
RUN usermod -a -G docker clouddev

RUN bash install_trivy.sh

RUN bash install_kubectl.sh

RUN bash install_aws_cli.sh

RUN bash install_psycopg_requirements.sh

RUN bash install_cypress_requirements.sh

USER clouddev

RUN mkdir /home/clouddev/tools

RUN bash install_cosign.sh
ENV PATH /home/clouddev/tools/cosign:$PATH

RUN bash install_argocd.sh
ENV PATH /home/clouddev/tools/argocd:$PATH

RUN bash install_miniconda.sh
ENV PATH /home/clouddev/miniconda3/bin:$PATH

RUN bash install_go.sh
ENV GOROOT /home/clouddev/tools/go
ENV GOPATH /home/clouddev/go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

RUN bash install_node.sh
RUN bash config_node_docker.sh
ENV PATH /home/clouddev/.nvm/versions/node/current/bin:$PATH

RUN bash install_java.sh
ENV PATH /home/clouddev/.sdkman/candidates/java/current/bin:$PATH
ENV PATH /home/clouddev/.sdkman/candidates/kotlin/current/bin:$PATH
ENV PATH /home/clouddev/.sdkman/candidates/gradle/current/bin:$PATH

RUN bash install_kind.sh
ENV PATH /home/clouddev/tools/kind:$PATH

RUN bash install_helm.sh
ENV PATH /home/clouddev/tools/helm:$PATH
RUN helm plugin install https://github.com/chartmuseum/helm-push

RUN bash install_istio.sh
ENV PATH /home/clouddev/tools/istio/bin:$PATH

RUN bash install_terraform.sh
ENV PATH /home/clouddev/tools/terraform:$PATH

RUN bash install_ansible.sh

WORKDIR /home/clouddev
RUN rm -rf /home/clouddev/src
