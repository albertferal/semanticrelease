#!/bin/bash

NEXT_RELEASE_VERSION="${1#"v"}"

function update_version_helm_chart_files() {
  echo "It's going to update appVersion in helm chart to version ${NEXT_RELEASE_VERSION}"
  yq w -i helm/fast-api-webapp/Chart.yaml "appVersion" "${NEXT_RELEASE_VERSION}"

  echo "It's going to update version in helm chart to version ${NEXT_RELEASE_VERSION}"
  yq w -i helm/fast-api-webapp/Chart.yaml "version" "${NEXT_RELEASE_VERSION}"

  echo "It's going to update image tag in helm chart values to version ${NEXT_RELEASE_VERSION}"
  yq w -i helm/fast-api-webapp/values.yaml "image.tag" "${NEXT_RELEASE_VERSION}"
}

function update_helm_docs() {
  echo "It's going to update README.md with helm-docs"
  helm-docs -c helm/fast-api-webapp/
}

function update_versions() {
  update_version_helm_chart_files
  update_helm_docs
}

update_versions