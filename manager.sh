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
    echo -e "  ${GREEN}sudo ./manager.sh install random${NC}   Install a random theme"
    echo -e "  ${GREEN}sudo ./manager.sh auto-random enable${NC} Enable theme randomization on boot"
    echo -e "  ${GREEN}sudo ./manager.sh uninstall${NC}        Remove current theme"
    echo -e "  ${GREEN}sudo ./manager.sh list${NC}             List all available themes"
    echo -e "  ${GREEN}./manager.sh --help${NC}                Show this help message"
    echo ""
    echo -e "${WHITE}Requirements:${NC}"
    echo -e "  • ${CYAN}ImageMagick${NC} (convert/magick)  — for image processing"
    echo -e "  • ${CYAN}grub2-tools${NC}                   — for grub2-mkfont & grub2-mkconfig"
    echo -e "  • ${CYAN}DejaVu Sans${NC} font              — for menu text rendering"
    echo -e "  • ${CYAN}chafa${NC} (optional)              — for terminal image previews"
    echo ""
    echo -e "${DIM}Dependencies are auto-installed if missing (Fedora/RHEL/CentOS).${NC}"
    echo ""
}

# ── List Themes ─────────────────────────────────────────────────────────────

# Global variables for pagination
PAGE=1
PER_PAGE=10
FILTER=""

list_themes() {
    local is_interactive="${1:-0}"
    local COL1=4
    local COL2=22
    local COL3=42

    echo ""
    printf "  ${WHITE}%-${COL1}s   %-${COL2}s   %-${COL3}s${NC}\n" "#" "Theme Name" "Description"
    printf "  ${DIM}%-${COL1}s   %-${COL2}s   %-${COL3}s${NC}\n" "----" "----------------------" "------------------------------------------"

    # Apply filter and get total count
    local filtered_themes=()
    for theme in "${THEMES[@]}"; do
        if [[ -z "${FILTER}" ]] || echo "${theme}" | grep -iq "${FILTER}"; then
            filtered_themes+=("${theme}")
        fi
    done

    local total=${#filtered_themes[@]}
    
    if [[ "${is_interactive}" == "1" ]]; then
        local total_pages=$(( (total + PER_PAGE - 1) / PER_PAGE ))
        if [[ $PAGE -gt $total_pages && $total_pages -gt 0 ]]; then PAGE=$total_pages; fi
        if [[ $PAGE -lt 1 ]]; then PAGE=1; fi
        
        local start=$(( (PAGE - 1) * PER_PAGE ))
        local end=$(( start + PER_PAGE ))
        
        for (( i=start; i<end; i++ )); do
            if [[ $i -ge $total ]]; then break; fi
            IFS='|' read -r num name desc bg <<< "${filtered_themes[$i]}"
            printf "  ${YELLOW}%-${COL1}s${NC}   ${CYAN}%-${COL2}s${NC}   ${DIM}%-${COL3}s${NC}\n" "${num}" "${name}" "${desc}"
        done
        
        echo ""
        if [[ -n "${FILTER}" ]]; then
            echo -e "  ${DIM}Filter active: '${FILTER}' (${total} matches)${NC}"
        fi
        echo -e "  ${DIM}Page ${PAGE} of ${total_pages:-1}${NC}"
    else
        # Not interactive, just print all (like old list)
        for theme in "${filtered_themes[@]}"; do
            IFS='|' read -r num name desc bg <<< "${theme}"
            printf "  ${YELLOW}%-${COL1}s${NC}   ${CYAN}%-${COL2}s${NC}   ${DIM}%-${COL3}s${NC}\n" "${num}" "${name}" "${desc}"
        done
    fi
    echo ""
}

# ── Interactive Menu ────────────────────────────────────────────────────────

interactive_menu() {
    while true; do
        clear
        print_banner
        list_themes 1

        echo -e "${WHITE}  Options:${NC}"
        echo -e "    ${GREEN}1-15${NC}    Install a theme"
        echo -e "    ${YELLOW}v <N>${NC}   Preview theme (e.g. 'v 7')"
        echo -e "    ${CYAN}r${NC}       Install a random theme"
        echo -e "    ${CYAN}f <str>${NC} Filter themes (e.g. 'f Vader', or 'f' to clear)"
        echo -e "    ${BLUE}← / →${NC}   Previous / Next Page (or p/n)"
        echo -e "    ${RED}u${NC}       Uninstall current theme"
        echo -e "    ${DIM}q${NC}       Quit"
        echo ""

        echo -ne "  ${YELLOW}*${NC} ${WHITE}Enter your choice:${NC} "
        
        local choice=""
        read -r -n 1 char
        if [[ "$char" == $'\e' ]]; then
            read -rs -n 2 -t 0.1 rest
            choice="$char$rest"
        else
            IFS= read -r rest
            choice="$char$rest"
        fi

        local cmd=""
        local arg=""
        
        if [[ "$choice" == $'\e[C' ]]; then
            cmd="NEXT_PAGE"
        elif [[ "$choice" == $'\e[D' ]]; then
            cmd="PREV_PAGE"
        else
            # parse first arg and rest
            cmd="${choice%% *}"
            arg="${choice#* }"
            if [[ "$cmd" == "$arg" ]]; then arg=""; fi
        fi

        case "${cmd}" in
            [1-9]|1[0-5])
                local padded=$(printf "%02d" "${cmd}")
                install_by_number "${padded}"
                break
                ;;
            v|V)
                if [[ -z "${arg}" ]]; then
                    echo -e "  ${RED}Please provide a theme number (e.g. 'v 7')${NC}"
                    sleep 2
                else
                    local padded=$(printf "%02d" "${arg}")
                    preview_theme "${padded}"
                    echo -ne "  ${DIM}Press Enter to continue...${NC}"
                    read -r
                fi
                ;;
            r|R)
                install_random
                break
                ;;
            f|F)
                FILTER="${arg}"
                PAGE=1
                ;;
            NEXT_PAGE|n|N)
                PAGE=$((PAGE + 1))
                ;;
            PREV_PAGE|p|P)
                PAGE=$((PAGE - 1))
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
            *)
                echo -e "  ${RED}Invalid choice.${NC}"
                sleep 1
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

# ── Random & Services ───────────────────────────────────────────────────────

install_random() {
    local count=${#THEMES[@]}
    local rand=$(( RANDOM % count ))
    local theme="${THEMES[$rand]}"
    IFS='|' read -r t_num t_name t_desc t_bg <<< "${theme}"
    echo -e "${YELLOW}★ Selected Random Theme: ${t_name} (${t_num}) ★${NC}"
    install_by_number "${t_num}"
}

setup_auto_random() {
    local OPT_DIR="/opt/starwars-grub"
    
    echo -e "  ${DIM}→ Copying files to ${OPT_DIR} for systemd service...${NC}"
    mkdir -p "${OPT_DIR}"
    cp -r "${SCRIPT_DIR}/manager.sh" "${SCRIPT_DIR}/scripts" "${SCRIPT_DIR}/backgrounds" "${OPT_DIR}/"
    chmod +x "${OPT_DIR}/manager.sh"
    
    # Ensure correct SELinux context if possible
    if command -v restorecon &>/dev/null; then
        restorecon -R "${OPT_DIR}"
    fi

    local SERVICE_PATH="/etc/systemd/system/grub2-random-theme.service"
    cat <<EOF > "${SERVICE_PATH}"
[Unit]
Description=Randomize GRUB2 Theme
After=multi-user.target

[Service]
Type=oneshot
ExecStart=${OPT_DIR}/manager.sh install random

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable grub2-random-theme.service
    echo -e "${GREEN}[OK]${NC} Auto-randomizer enabled! Theme will change on every boot."
}

remove_auto_random() {
    local SERVICE_PATH="/etc/systemd/system/grub2-random-theme.service"
    local OPT_DIR="/opt/starwars-grub"
    
    if [[ -f "${SERVICE_PATH}" ]]; then
        systemctl disable grub2-random-theme.service
        rm -f "${SERVICE_PATH}"
        systemctl daemon-reload
        echo -e "${GREEN}[OK]${NC} Auto-randomizer disabled."
        
        if [[ -d "${OPT_DIR}" ]]; then
            rm -rf "${OPT_DIR}"
            echo -e "  ${DIM}→ Removed ${OPT_DIR}${NC}"
        fi
    else
        echo -e "${YELLOW}[INFO]${NC} Auto-randomizer was not enabled."
    fi
}

preview_theme() {
    local num="${1}"
    local bg_file=""
    for theme in "${THEMES[@]}"; do
        IFS='|' read -r t_num t_name t_desc t_bg <<< "${theme}"
        if [[ "${t_num}" == "${num}" ]]; then
            bg_file="${t_bg}"
            break
        fi
    done
    
    if [[ -z "${bg_file}" || ! -f "${BACKGROUNDS_DIR}/${bg_file}" ]]; then
        echo -e "${RED}[ERROR]${NC} Background image not found."
        return
    fi
    
    if ! command -v chafa &>/dev/null; then
        echo -e "${YELLOW}[INFO]${NC} 'chafa' is not installed. Installing it for image previews..."
        if command -v dnf &>/dev/null; then
            dnf install -y chafa || echo "Failed to install chafa."
        elif command -v apt-get &>/dev/null; then
            apt-get update && apt-get install -y chafa || echo "Failed to install chafa."
        fi
    fi
    
    if command -v chafa &>/dev/null; then
        echo ""
        chafa "${BACKGROUNDS_DIR}/${bg_file}"
        echo ""
    else
        echo -e "${RED}[ERROR]${NC} Preview is not available (chafa missing)."
    fi
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
                echo -e "${RED}[ERROR]${NC} Please specify a theme number (1-15) or 'random'."
                echo -e "  ${DIM}Usage: sudo ./manager.sh install 7${NC}"
                exit 1
            fi

            if [[ "${2}" == "random" ]]; then
                install_random
            else
                local num="${2}"
                if [[ "${num}" -lt 1 || "${num}" -gt 15 ]] 2>/dev/null; then
                    echo -e "${RED}[ERROR]${NC} Theme number must be between 1 and 15."
                    exit 1
                fi
                local padded=$(printf "%02d" "${num}")
                install_by_number "${padded}"
            fi
            ;;
        auto-random)
            if [[ "${2:-}" == "enable" ]]; then
                setup_auto_random
            elif [[ "${2:-}" == "disable" ]]; then
                remove_auto_random
            else
                echo -e "${RED}[ERROR]${NC} Usage: sudo ./manager.sh auto-random enable|disable"
                exit 1
            fi
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
