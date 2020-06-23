#!/usr/bin/env bash

# keep script execution on errors
set +e

function installGo() {
    OS_ARCH=$1
    ARCH=$2
    GO_VERSION=$("${SCRIPTPATH}/../get_golang_version.sh")
    INSTALLED_GO_VERSION=$("${SCRIPTPATH}/../get_installed_golang_version.sh")
    echo "Ensure Go version ${GO_VERSION} for arch ${OS_ARCH}"

    if [[ "${INSTALLED_GO_VERSION}" != "${GO_VERSION}" ]]; then
        echo "Installing go version ${GO_VERSION} to replace ${INSTALLED_GO_VERSION}"
        if [[ "${ARCH}" = "amd64" ]]; then
            eval "$(gimme ${GO_VERSION})"
        else
            GO_TARBALL=go${GO_VERSION}.${OS_ARCH}.tar.gz
            wget -q https://dl.google.com/go/${GO_TARBALL}
            if [[ "$?" = "0" ]]; then
                set -e
                sudo tar -C /usr/local -xzf ${GO_TARBALL}
                rm -f ${GO_TARBALL}
                sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go
                sudo ln -sf /usr/local/go/bin/godoc /usr/local/bin/godoc
                sudo ln -sf /usr/local/go/bin/gofmt /usr/local/bin/gofmt
            else
                echo "Failed to download go"
                exit 1
            fi
        fi
    fi
}

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OS=$("${SCRIPTPATH}/../ostype.sh")
ARCH=$("${SCRIPTPATH}/../archtype.sh")

if [[ "${OS}" = "linux" ]]; then
    if [[ "${ARCH}" = "arm64" ]]; then
        installGo "linux-arm64" ${ARCH}
        set -e
        sudo apt-get update -y
        sudo apt-get -y install sqlite3 python3-venv libffi-dev libssl-dev
    elif [[ "${ARCH}" = "arm" ]]; then
        sudo sh -c 'echo "CONF_SWAPSIZE=1024" > /etc/dphys-swapfile; dphys-swapfile setup; dphys-swapfile swapon'
        installGo "linux-armv6l" ${ARCH}
        set -e
        sudo apt-get update -y
        sudo apt-get -y install sqlite3
    elif [[ "${ARCH}" = "amd64" ]]; then
        installGo "linux-amd64" ${ARCH}
    fi
elif [[ "${OS}" = "darwin" ]]; then
    installGo "darwin-amd64" ${ARCH}
    # we don't want to upgrade boost if we already have it, as it will try to update
    # other components.
    brew update
    brew tap homebrew/cask
    brew pin boost || true
fi

"${SCRIPTPATH}/../configure_dev.sh"
exit $?
