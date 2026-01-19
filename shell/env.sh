# Environment variables

# Detect OS
case "$(uname -s)" in
    Darwin)
        export IS_MACOS=1
        ;;
    Linux)
        export IS_LINUX=1
        ;;
esac
