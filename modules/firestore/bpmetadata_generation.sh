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


README_FILE="README.md"
METADATA_FILE="metadata.yaml"
DISPLAY_METADATA_FILE="metadata.display.yaml"

# If README doesn't exist, then create one with a title. This is used as the bpmetadata's name.
if [[ -f "$README_FILE" ]]; then
  echo "$README_FILE exists in the current directory."
else
  echo "$README_FILE does not exist in the current directory."

  # Take the README / module title as input from the user.
  IFS= read -r -p "Please provide the title for the terraform module: " module_title
  echo "The title you entered is: $module_title"

  # Create the README.md file.
  echo "# $module_title" > "$README_FILE"
  echo ""
  echo "Success! $README_FILE has been created with the title: '$module_title'"
  echo ""

fi

docker run --rm -it \
    -e ENABLE_BPMETADATA=1 \
    -v "$(pwd)":/workspace \
    gcr.io/cloud-foundation-cicd/cft/developer-tools:1.24 \
    /bin/bash -c 'source /usr/local/bin/task_helper_functions.sh && generate_docs display'

# Provide user access to the generated metadata files.
echo "The generated $METADATA_FILE and $DISPLAY_METADATA_FILE files only have root access. We will now provide user access to them so that this script can edit these files."
sudo chmod 777 ${METADATA_FILE}
sudo chmod 777 ${DISPLAY_METADATA_FILE}

# Add module's source directory.
HAS_DIR_KEY=$(yq e '.spec.info.source | has("dir")' "$METADATA_FILE")
if [[ "$HAS_DIR_KEY" == "false" ]]; then
    echo "The 'dir' key is missing in spec.info.source. of $METADATA_FILE"
    IFS= read -r -p "Please provide the module source directory in the repo (e.g., '/modules/example'). Press ENTER without adding anything if the module is in the root directory: " module_dir

    # Use yq to add the 'dir' key and the user-provided value to the YAML file.
    # The '-i' flag modifies the file in-place.
    if [[ -n "$module_dir" ]]; then
        yq -i ".spec.info.source.dir = \"$module_dir\"" "$METADATA_FILE"
        yq -i ".spec.info.source.dir = \"$module_dir\"" "$DISPLAY_METADATA_FILE"
        echo ""
        echo "Success! The key 'dir' has been added to $METADATA_FILE and $DISPLAY_METADATA_FILE files."
    fi
fi

# Add git as the source type.
yq -i ".spec.info.source.sourceType = \"git\"" "$METADATA_FILE"
yq -i ".spec.info.source.sourceType = \"git\"" "$DISPLAY_METADATA_FILE"

IFS= read -r -p "Please provide the module version in the semver format i.e. major.minor.patch (e.g., '1.2.5'). A corresponding git ref tag should be created in the format vX.Y.Z (e.g., 'v1.2.5') before ingesting the module to ADC: " module_version
if [[ -n "$module_version" ]]; then
    yq -i ".spec.info.version = \"$module_version\"" "$METADATA_FILE"
fi

echo ""
echo "$METADATA_FILE and $DISPLAY_METADATA_FILE have been successfully generated!"