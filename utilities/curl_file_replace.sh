################################################################################
# utilities::curl_file_replace
################################################################################
# Usage:
#   utilities::curl_file_replace <SOURCE_URL> <DEST_FILE>
#     <SOURCE_URL> is the full URL pointing to a file to download
#     <DEST_FILE> is the full path of the file to compare and replace
################################################################################
function utilities::curl_file_replace() {
  local SOURCE_URL="${1}"
  local DEST_FILE="${2}"
  local TEMP_FILE
  TEMP_FILE=$(mktemp)

  if [[ -z "${SOURCE_URL}" ]] || [[ -z "${DEST_FILE}" ]]; then
    messaging::status error "Source URL and destination file are required for curl utility."
    exit 1
  fi

  messaging::status notice "Downloading file from ${SOURCE_URL}"
  curl -sS -f -o "${TEMP_FILE}" "${SOURCE_URL}"
  if [[ $? -ne 0 ]]; then
    messaging::status error "Failed to download file from ${SOURCE_URL}."
    rm -f "${TEMP_FILE}"
    exit 1
  fi

  if [[ ! -f "${DEST_FILE}" ]]; then
    messaging::status notice "Destination file '${DEST_FILE}' not found. Creating it."
    mv "${TEMP_FILE}" "${DEST_FILE}"
  else
    # File exists, so compare checksums to see if a replacement is needed.
    sha256sum --status -c <(echo "$(sha256sum "${TEMP_FILE}" | awk '{print $1}')  ${DEST_FILE}")
    if [[ $? -eq 0 ]]; then
      # Success (exit code 0) means the checksums match.
      rm -f "${TEMP_FILE}"
    else
      # Failure (non-zero exit code) means the checksums differ.
      messaging::status notice "Configuration in '${DEST_FILE}' has changed. Applying update."
      mv "${TEMP_FILE}" "${DEST_FILE}"
    fi
  fi
}
