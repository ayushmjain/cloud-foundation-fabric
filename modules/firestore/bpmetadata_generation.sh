#!/bin/bash
# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


if [ -f "README.md" ]; then
  echo "README.md exists in the current directory."
else
  echo "README.md does not exist in the current directory."
  read -p "Please provide the title for the terraform module: " module_title
  echo "The title you entered is: $module_title"
  echo "# $module_title" > "README.md"
  echo ""
  echo "Success! README.md has been created with the title: '$module_title'"
fi

docker run --rm -it \
    -e ENABLE_BPMETADATA=1 \
    -v "$(pwd)":/workspace \
    gcr.io/cloud-foundation-cicd/cft/developer-tools:1.24 \
    /bin/bash -c 'source /usr/local/bin/task_helper_functions.sh && generate_docs display'

sudo chmod 777 metadata.yaml
sudo chmod 777 metadata.display.yaml

HAS_DIR_KEY=$(yq e '.spec.info.source | has("dir")' "metadata.yaml")
if [ "$HAS_DIR_KEY" == "false" ]; then
    echo "The 'dir' key is missing in spec.info.source. of metadata.yaml"
    read -p "Please provide the module source directory (e.g., '/modules/example'): " module_dir

    # Use yq to add the 'dir' key and the user-provided value to the YAML file.
    # The '-i' flag modifies the file in-place.
    if [ -n "$module_dir" ]; then
        yq -i ".spec.info.source.dir = \"$module_dir\"" "metadata.yaml"
        yq -i ".spec.info.source.dir = \"$module_dir\"" "metadata.display.yaml"
        echo ""
        echo "Success! The key 'dir' has been added to metadata.yaml file."
    fi
fi

yq -i ".spec.info.source.sourceType = \"git\"" "metadata.yaml"
yq -i ".spec.info.source.sourceType = \"git\"" "metadata.display.yaml"

read -p "Please provide the module version in the semver format i.e. major.minor.patch (e.g., '1.2.5'). A corresponding git ref tag should be created in the format vX.Y.Z (e.g., 'v1.2.5') before ingesting the module to ADC: " module_version
if [ -n "$module_version" ]; then
    yq -i ".spec.info.version = \"$module_version\"" "metadata.yaml"
fi