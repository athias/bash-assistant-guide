################################################################################
# messaging::message - Reports colorized Status Messages
################################################################################
# Usage:
#   messaging::message <STYLE> <COLOR> "message"
#     <STYLE> - normal, bold, dark, underline, inverse, strike/strikethrough
#     <COLOR> - red, yellow, green, blue, magenta/purple, cyan/teal, white, normal
################################################################################
function messaging::message() {
  local MESSAGE_STYLE
  local MESSAGE_COLOR
  local MESSAGE_TEXT
  MESSAGE_STYLE=${1}
  MESSAGE_COLOR=${2}
  shift 2
  MESSAGE_TEXT="${*}"

  if [[ -z ${MESSAGE_STYLE} ]] || [[ -z ${MESSAGE_COLOR} ]] || [[ -z ${MESSAGE_TEXT} ]];then
    messaging::status error "No valid arguments provided in 'messaging::message' call"
    exit 1
  fi

  case ${MESSAGE_STYLE} in
    normal|NORMAL) MESSAGE_STYLE='0' ;;
    bold|BOLD) MESSAGE_STYLE='1' ;;
    dark|DARK|subdued|SUBDUED) MESSAGE_STYLE='2' ;;
    underline|UNDERLINE) MESSAGE_STYLE='4' ;;
    inverse|INVERSE) MESSAGE_STYLE='7' ;;
    strike|STRIKE) MESSAGE_STYLE='9' ;;
    *)
      messaging::status error "No valid '<STYLE>' provided in 'messaging::message' call"
      exit 1
      ;;
  esac

  case ${MESSAGE_COLOR} in
    red|RED) MESSAGE_COLOR='31' ;;
    green|GREEN) MESSAGE_COLOR='32' ;;
    yellow|YELLOW) MESSAGE_COLOR='33' ;;
    blue|BLUE) MESSAGE_COLOR='34' ;;
    magenta|MAGENTA|purple|PURPLE) MESSAGE_COLOR='35' ;;
    cyan|CYAN|teal|TEAL) MESSAGE_COLOR='36' ;;
    white|WHITE) MESSAGE_COLOR='37' ;;
    normal|NORMAL) MESSAGE_COLOR='0' ;;
    *)
      messaging::status error "No valid '<COLOR>' provided in 'messaging::message' call"
      exit 1
      ;;
  esac

  printf "\\e[${MESSAGE_STYLE};${MESSAGE_COLOR}m${MESSAGE_TEXT}\\e[0m\\n"
}
