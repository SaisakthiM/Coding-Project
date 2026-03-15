#!/usr/bin/env bash
# =============================================================
#  merge_composes.sh  –  Scan a directory, find all
#                         docker-compose files and merge them
#                         into a single docker-compose.yml
#
#  Usage:
#    chmod +x merge_composes.sh
#    ./merge_composes.sh [TARGET_DIR] [OPTIONS]
#
#  Options:
#    -o, --output FILE   Output file path (default: ./merged-compose.yml)
#    -r, --run           Run the merged compose after generating
#    -d, --detach        Run in detached mode (requires --run)
#    -h, --help          Show this help
#
#  Examples:
#    ./merge_composes.sh ~/projects
#    ./merge_composes.sh ~/projects -o ~/merged-compose.yml
#    ./merge_composes.sh ~/projects --run --detach
# =============================================================

set -euo pipefail

# ── Colours ──────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

# ── Defaults ─────────────────────────────────────────────────
TARGET_DIR="${1:-.}"
OUTPUT_FILE="./merged-compose.yml"
RUN_AFTER=false
DETACH=false

# ── Parse args ───────────────────────────────────────────────
shift || true   # drop TARGET_DIR from args
while [[ $# -gt 0 ]]; do
  case $1 in
    -o|--output)  OUTPUT_FILE="$2"; shift 2 ;;
    -r|--run)     RUN_AFTER=true; shift ;;
    -d|--detach)  DETACH=true; shift ;;
    -h|--help)
      sed -n '3,20p' "$0" | sed 's/#  \?//'
      exit 0 ;;
    *) shift ;;
  esac
done

# ── Validate ─────────────────────────────────────────────────
if [[ ! -d "$TARGET_DIR" ]]; then
  echo -e "${RED}✗ Directory not found: $TARGET_DIR${RESET}"
  exit 1
fi
TARGET_DIR="$(realpath "$TARGET_DIR")"

# ── Dependency checks ─────────────────────────────────────────
for dep in docker python3; do
  command -v "$dep" &>/dev/null || { echo -e "${RED}✗ '$dep' not found.${RESET}"; exit 1; }
done

if docker compose version &>/dev/null 2>&1; then
  COMPOSE_CMD="docker compose"
elif command -v docker-compose &>/dev/null; then
  COMPOSE_CMD="docker-compose"
else
  echo -e "${RED}✗ docker compose not found.${RESET}"; exit 1
fi

# ── Banner ────────────────────────────────────────────────────
echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗"
echo -e "║     🐳  Compose Merger & Runner      ║"
echo -e "╚══════════════════════════════════════╝${RESET}"
echo -e "  Scanning : ${CYAN}$TARGET_DIR${RESET}"
echo -e "  Output   : ${CYAN}$OUTPUT_FILE${RESET}\n"

# ── Find all compose files ────────────────────────────────────
mapfile -t COMPOSE_FILES < <(find "$TARGET_DIR" \
  -type f \( \
    -name "docker-compose.yml" \
    -o -name "docker-compose.yaml" \
    -o -name "compose.yml" \
    -o -name "compose.yaml" \
  \) | sort)

if [[ ${#COMPOSE_FILES[@]} -eq 0 ]]; then
  echo -e "${YELLOW}⚠ No docker-compose files found in $TARGET_DIR${RESET}"
  exit 0
fi

echo -e "${BOLD}Found ${#COMPOSE_FILES[@]} compose file(s):${RESET}"
for f in "${COMPOSE_FILES[@]}"; do
  echo -e "  ${CYAN}•${RESET} $f"
done
echo ""

# ── Merge using Python (handles YAML properly) ────────────────
python3 - "${COMPOSE_FILES[@]}" "$OUTPUT_FILE" "$TARGET_DIR" <<'PYEOF'
import sys, os, re, copy

# Try PyYAML; fall back to install prompt
try:
    import yaml
except ImportError:
    print("PyYAML not found. Installing...")
    import subprocess
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pyyaml", "--quiet"])
    import yaml

compose_files = sys.argv[1:-2]
output_file   = sys.argv[-2]
target_dir    = sys.argv[-1]

# ── Helpers ───────────────────────────────────────────────────

def safe_name(path, target_dir):
    """Turn a project path into a safe unique prefix."""
    rel = os.path.relpath(os.path.dirname(path), target_dir)
    name = re.sub(r'[^a-zA-Z0-9]', '_', rel).strip('_').lower()
    # collapse repeated underscores
    name = re.sub(r'_+', '_', name)
    return name or "root"

def resolve_build_context(service, compose_dir):
    """Make build context paths absolute so merged file works from anywhere."""
    build = service.get("build")
    if not build:
        return service
    service = copy.deepcopy(service)
    if isinstance(build, str):
        service["build"] = os.path.abspath(os.path.join(compose_dir, build))
    elif isinstance(build, dict):
        ctx = build.get("context", ".")
        service["build"]["context"] = os.path.abspath(os.path.join(compose_dir, ctx))
        if "dockerfile" in build:
            # Leave dockerfile relative to context (that's correct Docker behaviour)
            pass
    return service

def resolve_volumes(service, compose_dir):
    """Make relative bind-mount host paths absolute."""
    service = copy.deepcopy(service)
    resolved = []
    for vol in service.get("volumes", []):
        if isinstance(vol, str):
            parts = vol.split(":")
            host = parts[0]
            # Only touch relative paths that look like file paths (start with . or /)
            if host.startswith(".") or (host.startswith("/") and os.path.exists(host)):
                parts[0] = os.path.abspath(os.path.join(compose_dir, host))
            resolved.append(":".join(parts))
        elif isinstance(vol, dict) and vol.get("type") == "bind":
            src = vol.get("source", "")
            if src.startswith("."):
                vol["source"] = os.path.abspath(os.path.join(compose_dir, src))
            resolved.append(vol)
        else:
            resolved.append(vol)
    if resolved:
        service["volumes"] = resolved
    return service

def resolve_env_file(service, compose_dir):
    """Make env_file paths absolute."""
    service = copy.deepcopy(service)
    ef = service.get("env_file")
    if not ef:
        return service
    if isinstance(ef, str):
        service["env_file"] = os.path.abspath(os.path.join(compose_dir, ef))
    elif isinstance(ef, list):
        service["env_file"] = [
            os.path.abspath(os.path.join(compose_dir, e)) if isinstance(e, str) else e
            for e in ef
        ]
    return service

# ── Merge loop ────────────────────────────────────────────────
merged = {
    "version": "3.8",
    "services": {},
    "volumes":  {},
    "networks": {},
}

name_count = {}   # track duplicates

for compose_path in compose_files:
    compose_dir = os.path.dirname(compose_path)
    prefix = safe_name(compose_path, target_dir)

    # Deduplicate prefixes
    name_count[prefix] = name_count.get(prefix, 0) + 1
    if name_count[prefix] > 1:
        prefix = f"{prefix}_{name_count[prefix]}"

    print(f"  → Merging [{prefix}]  {compose_path}")

    with open(compose_path) as f:
        data = yaml.safe_load(f) or {}

    services = data.get("services") or {}
    top_volumes = data.get("volumes") or {}
    top_networks = data.get("networks") or {}

    # Build a rename map: old_name -> new_name
    svc_rename = {svc: f"{prefix}__{svc}" for svc in services}

    # ── Process each service ──────────────────────────────────
    for svc_name, svc_def in services.items():
        if not svc_def:
            svc_def = {}
        new_name = svc_rename[svc_name]
        svc_def = copy.deepcopy(svc_def)

        # Fix paths
        svc_def = resolve_build_context(svc_def, compose_dir)
        svc_def = resolve_volumes(svc_def, compose_dir)
        svc_def = resolve_env_file(svc_def, compose_dir)

        # Rename depends_on references
        if "depends_on" in svc_def:
            dep = svc_def["depends_on"]
            if isinstance(dep, list):
                svc_def["depends_on"] = [svc_rename.get(d, d) for d in dep]
            elif isinstance(dep, dict):
                svc_def["depends_on"] = {
                    svc_rename.get(k, k): v for k, v in dep.items()
                }

        # Prefix named networks used by this service
        if "networks" in svc_def:
            nets = svc_def["networks"]
            if isinstance(nets, list):
                svc_def["networks"] = [f"{prefix}__{n}" for n in nets]
            elif isinstance(nets, dict):
                svc_def["networks"] = {f"{prefix}__{k}": v for k, v in nets.items()}

        # Prefix named volumes used by this service
        if "volumes" in svc_def:
            resolved = []
            for vol in svc_def["volumes"]:
                if isinstance(vol, str):
                    parts = vol.split(":")
                    # Named volume = doesn't start with . or /
                    if parts[0] in top_volumes:
                        parts[0] = f"{prefix}__{parts[0]}"
                    resolved.append(":".join(parts))
                else:
                    resolved.append(vol)
            svc_def["volumes"] = resolved

        # Add a label so you know which project this came from
        svc_def.setdefault("labels", {})
        if isinstance(svc_def["labels"], list):
            svc_def["labels"].append(f"com.docker-merger.project={prefix}")
        else:
            svc_def["labels"]["com.docker-merger.project"] = prefix

        merged["services"][new_name] = svc_def

    # ── Top-level volumes ─────────────────────────────────────
    for vol_name, vol_def in top_volumes.items():
        merged["volumes"][f"{prefix}__{vol_name}"] = vol_def or {}

    # ── Top-level networks ────────────────────────────────────
    for net_name, net_def in top_networks.items():
        merged["networks"][f"{prefix}__{net_name}"] = net_def or {}

# ── Clean up empty sections ───────────────────────────────────
if not merged["volumes"]:  del merged["volumes"]
if not merged["networks"]: del merged["networks"]

# ── Write output ──────────────────────────────────────────────
with open(output_file, "w") as f:
    f.write("# ============================================================\n")
    f.write("# AUTO-GENERATED by merge_composes.sh\n")
    f.write(f"# Source directory: {target_dir}\n")
    f.write(f"# Projects merged : {len(compose_files)}\n")
    f.write("# ============================================================\n\n")
    yaml.dump(merged, f, default_flow_style=False, sort_keys=False, allow_unicode=True)

print(f"\n✔ Merged {len(compose_files)} compose file(s) → {output_file}")
print(f"  Total services: {len(merged['services'])}")
PYEOF

echo ""

# ── Validate the merged file ──────────────────────────────────
echo -e "${BOLD}── Validating merged file ───────────────────${RESET}"
if $COMPOSE_CMD -f "$OUTPUT_FILE" config --quiet 2>&1; then
  echo -e "  ${GREEN}✔ Valid compose file${RESET}"
else
  echo -e "  ${YELLOW}⚠ Validation warnings above (may still work)${RESET}"
fi

# ── Optionally run ────────────────────────────────────────────
if $RUN_AFTER; then
  echo -e "\n${BOLD}── Starting all services ────────────────────${RESET}"
  run_args=("up")
  $FORCE_BUILD && run_args+=("--build")
  $DETACH      && run_args+=("-d")

  $COMPOSE_CMD -f "$OUTPUT_FILE" "${run_args[@]}"
else
  echo -e "\n${BOLD}── Next steps ───────────────────────────────${RESET}"
  echo -e "  Run all projects :"
  echo -e "  ${CYAN}docker compose -f $OUTPUT_FILE up${RESET}"
  echo -e "\n  Run detached     :"
  echo -e "  ${CYAN}docker compose -f $OUTPUT_FILE up -d${RESET}"
  echo -e "\n  Stop all         :"
  echo -e "  ${CYAN}docker compose -f $OUTPUT_FILE down${RESET}"
  echo -e "\n  See all services :"
  echo -e "  ${CYAN}docker compose -f $OUTPUT_FILE ps${RESET}\n"
fi