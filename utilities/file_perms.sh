################################################################################
# utilities::file_perms
################################################################################
# Usage:
#   utilities::file_perms <USER> <GROUP> <PERMS> <FILE>
#     <USER> is the intended user
#     <GROUP> is the indended group
#     <PERMS> is the 3-digit User/Group/Other permissions
#     <FILE> is the full path of the file to modify
################################################################################
function utilities::file_perms() {
  local CUR_USER="${1}"
  local CUR_GROUP="${2}"
  local CUR_PERMS="${3}"
  local CUR_FILE="${4}"

  # Validate inputs
  if [[ -z "${CUR_USER}" ]] || [[ -z "${CUR_GROUP}" ]] || [[ -z "${CUR_PERMS}" ]] || [[ -z "${CUR_FILE}" ]]; then
    messaging::status error "User, Group, Permissions, and File Path are required for file_perms utility."
    exit 1
  fi

  # Validate that CUR_USER is a valid user.
  if [[ -z $(id -u "${CUR_USER}" 2>/dev/null) ]]; then
    messaging::status error "User '${CUR_USER}' is not a valid user on this system."
    exit 1
  fi

  # Validate that CUR_GROUP is a valid group.
  if [[ -z $(getent group "${CUR_GROUP}" 2>/dev/null) ]]; then
    messaging::status error "Group '${CUR_GROUP}' is not a valid group on this system."
    exit 1
  fi

  # Validate that CUR_PERMS is a 3-digit number.
  if [[ ! ${CUR_PERMS} =~ ^[0-9]{3}$ ]]; then
    messaging::status error "Permissions must be a 3-digit number, but received '${CUR_PERMS}'."
    exit 1
  fi

  # Check if the file exists before attempting to modify it
  if [[ ! -f "${CUR_FILE}" ]]; then
    messaging::status error "File not found at '${CUR_FILE}', cannot set permissions."
    exit 1
  fi

  # Set ownership
  chown "${CUR_USER}":"${CUR_GROUP}" "${CUR_FILE}"
  if [[ $? -ne 0 ]]; then
    messaging::status error "Failed to set ownership on '${CUR_FILE}'."
    exit 1
  fi

  # Set permissions
  chmod "${CUR_PERMS}" "${CUR_FILE}"
  if [[ $? -ne 0 ]]; then
    messaging::status error "Failed to set permissions on '${CUR_FILE}'."
    exit 1
  fi

  # Restore SELinux context
  restorecon -F "${CUR_FILE}"
  if [[ $? -ne 0 ]]; then
    messaging::status warn "Failed to restore SELinux context on '${CUR_FILE}'. This may not be a critical error."
  fi
}
