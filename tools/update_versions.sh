#!/usr/bin/env bash
#
# Checks upstream sources for the latest available version of each tool and
# updates the corresponding variable in versions.sh accordingly.
#
# Usage:
#   ./update_versions.sh                 # check/update all versions
#   ./update_versions.sh DOCKER_VERSION   # check/update only a subset (substring match, space separated)

set -uo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VERSIONS_FILE="${SCRIPT_DIR}/versions.sh"
FILTER=("$@")

for cmd in curl jq sort; do
    if ! command -v "${cmd}" >/dev/null 2>&1; then
        echo "Required command '${cmd}' not found in PATH" >&2
        exit 1
    fi
done

GH_AUTH=()
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    GH_AUTH=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
fi

gh_latest_tag() {
    curl -sfL "${GH_AUTH[@]}" "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name // empty'
}

# Only run a check when no filter is given, or the variable name matches one of the filter args.
should_check() {
    local var_name=$1
    if [[ ${#FILTER[@]} -eq 0 ]]; then
        return 0
    fi
    local f
    for f in "${FILTER[@]}"; do
        if [[ "${var_name}" == *"${f}"* ]]; then
            return 0
        fi
    done
    return 1
}

update_version() {
    local var_name=$1
    local new_value=$2

    if ! should_check "${var_name}"; then
        return
    fi

    if [[ -z "${new_value}" ]]; then
        echo "  ${var_name}: could not determine latest version, skipping"
        return
    fi

    local old_value
    old_value=$(grep -m1 "^${var_name}=" "${VERSIONS_FILE}" | sed -E 's/^[A-Z_0-9]+="(.*)"$/\1/')

    if [[ "${old_value}" == "${new_value}" ]]; then
        echo "  ${var_name}: ${old_value} (up to date)"
    else
        sed -i "s|^${var_name}=.*|${var_name}=\"${new_value}\"|" "${VERSIONS_FILE}"
        echo "  ${var_name}: ${old_value} -> ${new_value}"
    fi
}

echo "Checking software development tool versions..."

if should_check MINICONDA_VERSION; then
    update_version MINICONDA_VERSION "$(curl -sf https://repo.anaconda.com/miniconda/ \
        | grep -oE 'Miniconda3-py3[0-9]+_[0-9.]+-[0-9]+-Linux-x86_64\.sh' \
        | sed -E 's/Miniconda3-(.*)-Linux-x86_64\.sh/\1/' | sort -V | tail -1)"
fi

update_version CONDA_VERSION "$(curl -sf https://api.anaconda.org/package/anaconda/conda | jq -r '.latest_version // empty')"
update_version PYTHON_VERSION "$(curl -sf https://api.anaconda.org/package/anaconda/python | jq -r '.latest_version // empty')"
update_version UV_VERSION "$(curl -sf https://pypi.org/pypi/uv/json | jq -r '.info.version // empty')"

if should_check NVM_VERSION; then
    tag=$(gh_latest_tag nvm-sh/nvm)
    update_version NVM_VERSION "${tag#v}"
fi

if should_check NODE_VERSION || should_check NPM_VERSION; then
    node_lts_entry=$(curl -sf https://nodejs.org/dist/index.json | jq -c '[.[] | select(.lts != false)][0]')
    node_version=$(echo "${node_lts_entry}" | jq -r '.version // empty')
    npm_version=$(echo "${node_lts_entry}" | jq -r '.npm // empty')
    update_version NODE_VERSION "${node_version#v}"
    update_version NPM_VERSION "${npm_version}"
fi

if should_check YARN_VERSION; then
    tag=$(gh_latest_tag yarnpkg/berry)
    update_version YARN_VERSION "${tag##*/}"
fi

# Java LTS releases are 8, 11, then every 4 majors starting at 17 (17, 21, 25, 29, ...).
is_java_lts_major() {
    local m=$1
    [[ "${m}" -eq 8 || "${m}" -eq 11 ]] && return 0
    [[ "${m}" -ge 17 && $(( (m - 17) % 4 )) -eq 0 ]]
}

if should_check JAVA_VERSION; then
    zulu_block=$(curl -sf "https://api.sdkman.io/2/candidates/java/linux/versions/list?installed=" \
        | awk '/^ Zulu/{f=1} f{print} f && !/^ Zulu/ && !/-zulu$/{exit}')
    best_major=0
    best_version=""
    while read -r v; do
        [[ -z "${v}" ]] && continue
        major=${v%%.*}
        if is_java_lts_major "${major}" && (( major > best_major )); then
            best_major=${major}
            best_version=${v}
        fi
    done <<< "$(echo "${zulu_block}" | awk -F'|' '{print $3}' | tr -d ' ' | grep -vE '\.fx|\.crac|-fx|-crac')"
    update_version JAVA_VERSION "$(echo "${best_version}" | grep -oE '^[0-9]+\.[0-9]+\.[0-9]+')"
fi

update_version KOTLIN_VERSION "$(curl -sf https://api.sdkman.io/2/candidates/default/kotlin)"
update_version GROOVY_VERSION "$(curl -sf https://api.sdkman.io/2/candidates/default/groovy)"
update_version GRADLE_VERSION "$(curl -sf https://api.sdkman.io/2/candidates/default/gradle)"
update_version MAVEN_VERSION "$(curl -sf https://api.sdkman.io/2/candidates/default/maven)"

echo "Checking Docker tool versions..."

if should_check DOCKER_VERSION; then
    docker_version=$(apt-cache madison docker-ce 2>/dev/null | head -1 | awk -F'|' '{print $2}' | tr -d ' ')
    if [[ -z "${docker_version}" ]]; then
        echo "  DOCKER_VERSION: docker-ce apt repository not configured, skipping (run tools/install_docker.sh first)"
    else
        update_version DOCKER_VERSION "${docker_version}"
    fi
fi

if should_check TRIVY_VERSION; then
    tag=$(gh_latest_tag aquasecurity/trivy)
    update_version TRIVY_VERSION "${tag#v}"
fi

if should_check COSIGN_VERSION; then
    tag=$(gh_latest_tag sigstore/cosign)
    update_version COSIGN_VERSION "${tag#v}"
fi

echo "Checking Kubernetes tool versions..."

if should_check MICROK8S_VERSION; then
    track=$(curl -sf "https://api.snapcraft.io/v2/snaps/info/microk8s" -H "Snap-Device-Series: 16" \
        | jq -r '.["channel-map"][] | select(.channel.risk=="stable") | .channel.track' \
        | grep -E '^[0-9]+\.[0-9]+$' | sort -V | tail -1)
    if [[ -n "${track}" ]]; then
        update_version MICROK8S_VERSION "${track}/stable"
    else
        update_version MICROK8S_VERSION ""
    fi
fi

if should_check KIND_VERSION; then
    tag=$(gh_latest_tag kubernetes-sigs/kind)
    update_version KIND_VERSION "${tag#v}"
fi

if should_check KUBECTL_VERSION; then
    tag=$(curl -sf https://dl.k8s.io/release/stable.txt)
    update_version KUBECTL_VERSION "${tag#v}"
fi

if should_check HELM_VERSION; then
    tag=$(gh_latest_tag helm/helm)
    update_version HELM_VERSION "${tag#v}"
fi

if should_check K9S_VERSION; then
    tag=$(gh_latest_tag derailed/k9s)
    update_version K9S_VERSION "${tag#v}"
fi

if should_check ISTIO_VERSION; then
    tag=$(gh_latest_tag istio/istio)
    update_version ISTIO_VERSION "${tag#v}"
fi

if should_check ARGOCD_VERSION; then
    tag=$(gh_latest_tag argoproj/argo-cd)
    update_version ARGOCD_VERSION "${tag#v}"
fi

if should_check TEKTON_VERSION; then
    tag=$(gh_latest_tag tektoncd/cli)
    update_version TEKTON_VERSION "${tag#v}"
fi

if should_check VELERO_VERSION; then
    tag=$(gh_latest_tag vmware-tanzu/velero)
    update_version VELERO_VERSION "${tag#v}"
fi

echo "Checking provisioning tool versions..."

if should_check AWS_CLI_VERSION; then
    update_version AWS_CLI_VERSION "$(curl -sf https://raw.githubusercontent.com/aws/aws-cli/v2/CHANGELOG.rst \
        | grep -m1 -oE '^[0-9]+\.[0-9]+\.[0-9]+')"
fi

update_version AZURE_CLI_VERSION "$(curl -sf https://pypi.org/pypi/azure-cli/json | jq -r '.info.version // empty')"

if should_check HCLOUD_VERSION; then
    tag=$(gh_latest_tag hetznercloud/cli)
    update_version HCLOUD_VERSION "${tag#v}"
fi

if should_check DOCTL_VERSION; then
    tag=$(gh_latest_tag digitalocean/doctl)
    update_version DOCTL_VERSION "${tag#v}"
fi

if should_check TERRAFORM_VERSION; then
    tag=$(gh_latest_tag hashicorp/terraform)
    update_version TERRAFORM_VERSION "${tag#v}"
fi

if should_check TOFU_VERSION; then
    tofu_version=$(apt-cache madison tofu 2>/dev/null | head -1 | awk -F'|' '{print $2}' | tr -d ' ')
    if [[ -z "${tofu_version}" ]]; then
        echo "  TOFU_VERSION: tofu apt repository not configured, skipping (run tools/install_tofu.sh first)"
    else
        update_version TOFU_VERSION "${tofu_version}"
    fi
fi

update_version ANSIBLE_VERSION "$(curl -sf https://pypi.org/pypi/ansible/json | jq -r '.info.version // empty')"

echo "Checking test tool versions..."

if should_check ZAP_VERSION; then
    tag=$(gh_latest_tag zaproxy/zaproxy)
    update_version ZAP_VERSION "${tag#v}"
fi

if should_check SONAR_CLI_VERSION; then
    update_version SONAR_CLI_VERSION "$(curl -sf https://repo1.maven.org/maven2/org/sonarsource/scanner/cli/sonar-scanner-cli/maven-metadata.xml \
        | grep -m1 -oE '<release>[^<]*</release>' | sed -E 's/<\/?release>//g')"
fi

echo "Done."
