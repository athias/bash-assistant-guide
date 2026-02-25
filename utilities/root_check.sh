################################################################################
# utilities::root_check
################################################################################
# Global Variables Used:
#   EUID (special shell variable)
################################################################################
function utilities::root_check() {
  if [[ ${EUID} -ne 0 ]];then
    messaging::status error "This script requires 'root' access to run properly - exiting!"
    exit 1
  fi
}
