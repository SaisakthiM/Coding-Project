#!/usr/bin/env bash
# =============================================================
#  docker_runner.sh  –  Build & run all Docker projects under
#                        a given directory (recursive scan)
#
#  Usage:
#    chmod +x docker_runner.sh
#    ./docker_runner.sh [TARGET_DIR] [OPTIONS]
#
#  Options:
#    -d, --detach      Run containers in background (detached)
#    -b, --build       Force rebuild images before starting
#    -s, --stop        Stop & remove all found compose stacks
#    -p, --prune       Prune unused images/volumes after run
#    -h, --help        Show this help
#
#  Examples:
#    ./docker_runner.sh ~/projects
#    ./docker_runner.sh ~/projects --detach --build
#    ./docker_runner.sh ~/projects --stop
# =============================================================

set -euo pipefail

# ── Colours ──────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

# ── Defaults ─────────────────────────────────────────────────
TARGET_DIR="${1:-.}"
DETACH=false
FORCE_BUILD=false
STOP_MODE=false
PRUNE=false

# ── Parse args ───────────────────────────────────────────────
for arg in "$@"; do
  case $arg in
    -d|--detach)  DETACH=true ;;
    -b|--build)   FORCE_BUILD=true ;;
    -s|--stop)    STOP_MODE=true ;;
    -p|--prune)   PRUNE=true ;;
    -h|--help)
      sed -n '3,20p' "$0" | sed 's/#  \?//'
      exit 0 ;;
  esac
done

# ── Validate target directory ─────────────────────────────────
if [[ ! -d "$TARGET_DIR" ]]; then
  echo -e "${RED}✗ Directory not found: $TARGET_DIR${RESET}"
  exit 1
fi
TARGET_DIR="$(realpath "$TARGET_DIR")"

# ── Dependency checks ─────────────────────────────────────────
check_dep() {
  command -v "$1" &>/dev/null || { echo -e "${RED}✗ '$1' not found. Please install it.${RESET}"; exit 1; }
}
check_dep docker

# Detect docker compose (v2 plugin vs standalone v1)
if docker compose version &>/dev/null 2>&1; then
  COMPOSE_CMD="docker compose"
elif command -v docker-compose &>/dev/null; then
  COMPOSE_CMD="docker-compose"
else
  COMPOSE_CMD=""
fi

# ── Counters ──────────────────────────────────────────────────
COMPOSE_OK=0; COMPOSE_FAIL=0
DOCKER_OK=0;  DOCKER_FAIL=0

# ── Banner ────────────────────────────────────────────────────
echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗"
echo -e "║       🐳  Docker Project Runner      ║"
echo -e "╚══════════════════════════════════════╝${RESET}"
echo -e "  Target : ${CYAN}$TARGET_DIR${RESET}"
echo -e "  Mode   : $(${STOP_MODE} && echo 'STOP' || echo 'RUN') | Detach: $DETACH | Force-build: $FORCE_BUILD\n"

# ─────────────────────────────────────────────────────────────
#  SECTION 1 – docker-compose files
# ─────────────────────────────────────────────────────────────
if [[ -n "$COMPOSE_CMD" ]]; then
  echo -e "${BOLD}── Docker Compose Projects ──────────────────${RESET}"

  # Find all compose files (compose.yml, compose.yaml, docker-compose.yml, docker-compose.yaml)
  while IFS= read -r compose_file; do
    project_dir="$(dirname "$compose_file")"
    project_name="$(basename "$project_dir")"

    echo -e "\n${YELLOW}▸ $project_name${RESET}  (${compose_file})"

    if $STOP_MODE; then
      # ── Stop mode ──────────────────────────────────────────
      if $COMPOSE_CMD -f "$compose_file" down --remove-orphans 2>&1 | \
           sed 's/^/    /'; then
        echo -e "  ${GREEN}✔ Stopped${RESET}"
        (( COMPOSE_OK++ )) || true
      else
        echo -e "  ${RED}✗ Failed to stop${RESET}"
        (( COMPOSE_FAIL++ )) || true
      fi
    else
      # ── Run mode ───────────────────────────────────────────
      compose_args=()
      $FORCE_BUILD && compose_args+=("--build")
      $DETACH      && compose_args+=("-d")

      if $COMPOSE_CMD -f "$compose_file" up "${compose_args[@]}" 2>&1 | \
           sed 's/^/    /'; then
        echo -e "  ${GREEN}✔ Started${RESET}"
        (( COMPOSE_OK++ )) || true
      else
        echo -e "  ${RED}✗ Failed to start${RESET}"
        (( COMPOSE_FAIL++ )) || true
      fi
    fi

  done < <(find "$TARGET_DIR" \
      -type f \( \
        -name "docker-compose.yml" \
        -o -name "docker-compose.yaml" \
        -o -name "compose.yml" \
        -o -name "compose.yaml" \
      \) \
      | sort)
else
  echo -e "${YELLOW}⚠ docker compose not available – skipping compose files${RESET}"
fi

# ─────────────────────────────────────────────────────────────
#  SECTION 2 – Standalone Dockerfiles
#  (only those NOT inside a directory that already has a
#   compose file, to avoid double-processing)
# ─────────────────────────────────────────────────────────────
echo -e "\n${BOLD}── Standalone Dockerfiles ───────────────────${RESET}"

# Collect directories that already have a compose file
compose_dirs=()
while IFS= read -r f; do
  compose_dirs+=("$(dirname "$(realpath "$f")")")
done < <(find "$TARGET_DIR" \
    -type f \( \
      -name "docker-compose.yml" -o -name "docker-compose.yaml" \
      -o -name "compose.yml"     -o -name "compose.yaml" \
    \))

is_compose_dir() {
  local dir="$1"
  for cd in "${compose_dirs[@]:-}"; do
    [[ "$dir" == "$cd" ]] && return 0
  done
  return 1
}

found_standalone=false

while IFS= read -r dockerfile; do
  project_dir="$(dirname "$dockerfile")"

  # Skip if already covered by compose
  is_compose_dir "$project_dir" && continue

  found_standalone=true
  project_name="$(basename "$project_dir")"
  image_tag="docker-runner/$(echo "$project_name" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/-*$//')"

  echo -e "\n${YELLOW}▸ $project_name${RESET}  (${dockerfile})"

  if $STOP_MODE; then
    # Stop any running containers from this image
    containers=$(docker ps -q --filter "ancestor=$image_tag" 2>/dev/null || true)
    if [[ -n "$containers" ]]; then
      docker stop $containers 2>&1 | sed 's/^/    /'
      docker rm   $containers 2>&1 | sed 's/^/    /'
      echo -e "  ${GREEN}✔ Stopped${RESET}"
    else
      echo -e "  ${CYAN}ℹ No running containers for image $image_tag${RESET}"
    fi
    (( DOCKER_OK++ )) || true
  else
    # Build
    echo -e "  ${CYAN}→ Building image: $image_tag${RESET}"
    if ! docker build -t "$image_tag" "$project_dir" 2>&1 | sed 's/^/    /'; then
      echo -e "  ${RED}✗ Build failed – skipping run${RESET}"
      (( DOCKER_FAIL++ )) || true
      continue
    fi

    # Run
    echo -e "  ${CYAN}→ Running container${RESET}"
    run_args=()
    $DETACH && run_args+=("-d") || run_args+=("--rm")

    if docker run "${run_args[@]}" --name "${project_name}-$(date +%s)" \
         "$image_tag" 2>&1 | sed 's/^/    /'; then
      echo -e "  ${GREEN}✔ Running${RESET}"
      (( DOCKER_OK++ )) || true
    else
      echo -e "  ${RED}✗ Run failed${RESET}"
      (( DOCKER_FAIL++ )) || true
    fi
  fi

done < <(find "$TARGET_DIR" -name "Dockerfile" -type f | sort)

$found_standalone || echo -e "  ${CYAN}ℹ No standalone Dockerfiles found${RESET}"

# ─────────────────────────────────────────────────────────────
#  SECTION 3 – Optional prune
# ─────────────────────────────────────────────────────────────
if $PRUNE && ! $STOP_MODE; then
  echo -e "\n${BOLD}── Pruning unused resources ─────────────────${RESET}"
  docker image prune -f  2>&1 | sed 's/^/  /'
  docker volume prune -f 2>&1 | sed 's/^/  /'
fi

# ─────────────────────────────────────────────────────────────
#  Summary
# ─────────────────────────────────────────────────────────────
echo -e "\n${BOLD}${CYAN}── Summary ──────────────────────────────────${RESET}"
echo -e "  Compose  : ${GREEN}${COMPOSE_OK} ok${RESET}  ${RED}${COMPOSE_FAIL} failed${RESET}"
echo -e "  Docker   : ${GREEN}${DOCKER_OK} ok${RESET}  ${RED}${DOCKER_FAIL} failed${RESET}"

total_fail=$(( COMPOSE_FAIL + DOCKER_FAIL ))
if (( total_fail > 0 )); then
  echo -e "\n${RED}⚠ $total_fail project(s) had errors. Check output above.${RESET}\n"
  exit 1
else
  echo -e "\n${GREEN}✔ All done!${RESET}\n"
fi