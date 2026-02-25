################################################################################
# messaging::status - Reports colorized Status Messages
################################################################################
# Usage:
#   messaging::status <STATUS> "<MESSAGE>"
#    <STATUS> - error, success, fail, warning, notice
#    <MESSAGE> - must be in quotes
################################################################################
function messaging::status() {
  local MESSAGE_STATUS
  local MESSAGE_TEXT
  MESSAGE_STATUS=${1}
  shift 1
  MESSAGE_TEXT="${*}"

  if [[ -z ${MESSAGE_TEXT} ]];then
    printf "  \e[0;31mERROR:\e[0m    No valid arguments provided in 'messaging::status' call\n"
    exit 1
  fi

  case ${MESSAGE_STATUS} in
    error|ERROR) printf "  \e[0;31mERROR:\e[0m    ${MESSAGE_TEXT}\n" ;;
    fail|FAIL) printf "  \e[0;31mFAILURE:\e[0m  ${MESSAGE_TEXT}\n" ;;
    success|SUCCESS) printf "  \e[0;32mSUCCESS:\e[0m  ${MESSAGE_TEXT}\n" ;;
    warn|WARN) printf "  \e[0;33mWARNING:\e[0m  ${MESSAGE_TEXT}\n" ;;
    notice|NOTICE) printf "  \e[0;36mNOTICE:\e[0m   ${MESSAGE_TEXT}\n" ;;
    *)
      printf "  \e[0;31mERROR:\e[0m    No valid '<STATUS>' provided in 'messaging::status' call\n"
      exit 1
      ;;
  esac
}
