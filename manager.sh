#!/usr/bin/env bash
# ============================================================================
#  ★ Star Wars GRUB2 Theme Manager ★
#  Author: Futhark1393
#
#  Interactive CLI tool to browse, preview, and install Star Wars GRUB2 themes.
#  Supports 15 curated backgrounds with optimized color palettes.
#
#  Usage:
#    sudo ./manager.sh              # Interactive mode
#    sudo ./manager.sh install <N>  # Direct install theme N (1-15)
#    sudo ./manager.sh uninstall    # Remove theme
#    sudo ./manager.sh list         # List available themes
#    ./manager.sh --help            # Show help
# ============================================================================

set -euo pipefail

# ── Resolve Paths ───────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"
BACKGROUNDS_DIR="${SCRIPT_DIR}/backgrounds"

# ── Theme Database ──────────────────────────────────────────────────────────
# Format: "Number|Name|Description|Background"

THEMES=(
    "01|Tatooine Sunset|Cloaked figure watching twin suns|background1.png"
    "02|A New Hope|Classic original trilogy poster artwork|background2.png"
    "03|Imperial Remnants|Crashed TIE fighters in misty landscape|background3.png"
    "04|The Force Awakens|Four-panel art: forest, desert, lake, fire|background4.png"
    "05|Battle of Bespin|Falcon and X-Wings over Cloud City|background5.png"
    "06|The Kessel Run|Falcon soaring over desert at sunset|background6.png"
    "07|The Dark Side|Darth Vader portrait, cold blue atmosphere|background7.png"
    "08|A Galaxy Far Away|All Star Wars characters group photo|background8.png"
    "09|Red Squadron|X-Wing fighters in formation at sunset|background9.png"
    "10|That's No Moon|Death Star II over blue night with AT-ATs|background10.png"
    "11|Ultimate Power|Classic Death Star in the void of space|background11.png"
    "12|The Chosen One|Obi-Wan vs Anakin duel on Mustafar|background12.png"
    "13|Punch It, Chewie!|Falcon cruising through deep space|background13.png"
    "14|Orbital Approach|Falcon descending over a desert planet|background14.png"
    "15|Do or Do Not|Master Yoda on Dagobah in the swamp|background15.png"
)

# ── Color Functions ─────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ── Banner ──────────────────────────────────────────────────────────────────

print_banner() {
    # Each line between pipes is exactly 58 visible characters
    echo ""
    echo -e "${YELLOW}  +==========================================================+"
    echo "  |                                                          |"
    echo "  |     * S T A R  W A R S  G R U B 2  M A N A G E R  *      |"
    echo "  |                                                          |"
    echo "  |                   Author: Futhark1393                    |"
    echo "  |                                                          |"
    echo -e "  +==========================================================+${NC}"
    echo ""
}

# ── Help ────────────────────────────────────────────────────────────────────

show_help() {
    print_banner
    echo -e "${WHITE}Usage:${NC}"
    echo -e "  ${GREEN}sudo ./manager.sh${NC}                  Interactive theme selector"
    echo -e "  ${GREEN}sudo ./manager.sh install <1-15>${NC}   Install theme by number"
    echo -e "  ${GREEN}sudo ./manager.sh uninstall${NC}        Remove current theme"
    echo -e "  ${GREEN}sudo ./manager.sh list${NC}             List all available themes"
    echo -e "  ${GREEN}./manager.sh --help${NC}                Show this help message"
    echo ""
    echo -e "${WHITE}Requirements:${NC}"
    echo -e "  • ${CYAN}ImageMagick${NC} (convert/magick)  — for image processing"
    echo -e "  • ${CYAN}grub2-tools${NC}                   — for grub2-mkfont & grub2-mkconfig"
    echo -e "  • ${CYAN}DejaVu Sans${NC} font              — for menu text rendering"
    echo ""
    echo -e "${DIM}Dependencies are auto-installed if missing (Fedora/RHEL/CentOS).${NC}"
    echo ""
}

# ── List Themes ─────────────────────────────────────────────────────────────

list_themes() {
    local COL1=4   # number width
    local COL2=22  # name width
    local COL3=42  # description width

    echo ""
    # Header
    printf "  ${WHITE}%-${COL1}s   %-${COL2}s   %-${COL3}s${NC}\n" "#" "Theme Name" "Description"
    printf "  ${DIM}%-${COL1}s   %-${COL2}s   %-${COL3}s${NC}\n" "----" "----------------------" "------------------------------------------"

    for theme in "${THEMES[@]}"; do
        IFS='|' read -r num name desc bg <<< "${theme}"
        printf "  ${YELLOW}%-${COL1}s${NC}   ${CYAN}%-${COL2}s${NC}   ${DIM}%-${COL3}s${NC}\n" "${num}" "${name}" "${desc}"
    done

    echo ""
}

# ── Interactive Menu ────────────────────────────────────────────────────────

interactive_menu() {
    print_banner
    list_themes

    echo -e "${WHITE}  Options:${NC}"
    echo -e "    ${GREEN}1-15${NC}    Install a theme"
    echo -e "    ${RED}u${NC}       Uninstall current theme"
    echo -e "    ${DIM}q${NC}       Quit"
    echo ""

    while true; do
        echo -ne "  ${YELLOW}*${NC} ${WHITE}Enter your choice:${NC} "
        read -r choice

        case "${choice}" in
            [1-9]|1[0-5])
                # Pad single digit with leading zero
                local padded
                padded=$(printf "%02d" "${choice}")
                install_by_number "${padded}"
                break
                ;;
            u|U)
                source "${SCRIPTS_DIR}/theme-engine.sh"
                uninstall_theme
                break
                ;;
            q|Q)
                echo ""
                echo -e "  ${DIM}May the Force be with you.${NC}"
                echo ""
                exit 0
                ;;
            --help|-h|help)
                show_help
                break
                ;;
            *)
                echo -e "  ${RED}Invalid choice.${NC} Enter a number (1-15), 'u' to uninstall, or 'q' to quit."
                ;;
        esac
    done
}

# ── Install By Number ───────────────────────────────────────────────────────

install_by_number() {
    local num="${1}"
    local script="${SCRIPTS_DIR}/theme-${num}.sh"

    if [[ ! -f "${script}" ]]; then
        echo -e "${RED}[ERROR]${NC} Theme script not found: ${script}"
        exit 1
    fi

    # Verify background exists
    local bg_file=""
    for theme in "${THEMES[@]}"; do
        IFS='|' read -r t_num t_name t_desc t_bg <<< "${theme}"
        if [[ "${t_num}" == "${num}" ]]; then
            bg_file="${t_bg}"
            break
        fi
    done

    if [[ -n "${bg_file}" && ! -f "${BACKGROUNDS_DIR}/${bg_file}" ]]; then
        echo -e "${RED}[ERROR]${NC} Background image not found: ${BACKGROUNDS_DIR}/${bg_file}"
        exit 1
    fi

    echo ""
    echo -e "  ${GREEN}▸ Installing theme ${num}...${NC}"
    echo ""

    bash "${script}"
}

# ── Main ────────────────────────────────────────────────────────────────────

main() {
    # Handle --help before root check
    if [[ "${1:-}" == "--help" || "${1:-}" == "-h" || "${1:-}" == "help" ]]; then
        show_help
        exit 0
    fi

    if [[ "${1:-}" == "list" ]]; then
        print_banner
        list_themes
        exit 0
    fi

    # Root check for install/uninstall operations
    if [[ $EUID -ne 0 && "${1:-}" != "list" && "${1:-}" != "--help" && "${1:-}" != "-h" ]]; then
        echo -e "${RED}[ERROR]${NC} This script must be run as root (sudo)."
        echo -e "  ${DIM}Usage: sudo ./manager.sh${NC}"
        echo -e "  ${DIM}For help: ./manager.sh --help${NC}"
        exit 1
    fi

    case "${1:-}" in
        install)
            if [[ -z "${2:-}" ]]; then
                echo -e "${RED}[ERROR]${NC} Please specify a theme number (1-15)."
                echo -e "  ${DIM}Usage: sudo ./manager.sh install 7${NC}"
                exit 1
            fi

            local num="${2}"
            if [[ "${num}" -lt 1 || "${num}" -gt 15 ]] 2>/dev/null; then
                echo -e "${RED}[ERROR]${NC} Theme number must be between 1 and 15."
                exit 1
            fi

            local padded
            padded=$(printf "%02d" "${num}")
            install_by_number "${padded}"
            ;;
        uninstall)
            source "${SCRIPTS_DIR}/theme-engine.sh"
            uninstall_theme
            ;;
        list)
            print_banner
            list_themes
            ;;
        "")
            interactive_menu
            ;;
        *)
            echo -e "${RED}[ERROR]${NC} Unknown command: ${1}"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
