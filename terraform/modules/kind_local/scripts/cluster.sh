#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

_cluster_exists() {
    local _cluster_name="$1"
    kind get clusters | grep "$_cluster_name"
}

create() {
    local _cluster_name="$1"
    local _config_file="$2"

    if _cluster_exists "$_cluster_name"; then
        echo "Cluster $_cluster_name exists. Skip create cluster."
    else
        kind create cluster --config="$_config_file"
    fi
}

delete() {
    local _cluster_name="$1"

    if _cluster_exists "$_cluster_name"; then
        kind delete cluster --name="$_cluster_name"
    else
        echo "Cluster $_cluster_name doesn't exist. Skip delete cluster."
    fi
}

$1 "${@:2}"