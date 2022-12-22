#!/usr/bin/env bash
set -e

showhelp() {
  echo "[?] Usage: $0 --dir <PATH> [--no-repo --remove]"
  echo "----------------------------------------------"
  echo -e "[+]\t--dir: R package folder"
  echo -e "[+]\t--no-repo: Skip publishing to private repository"
  echo -e "[+]\t--remove: Remove package before installation"
  echo -e "[+]\t-h|--help: Show this help"
  echo -e "[+] NOTES:"
  echo -e "\t\t- Needs R and devtools + testthat packages"
  echo -e "\t\t- Repository upload requires curl and to set"
  echo -e "\t\t\tREPO_URL and REPO_USER environment variables."
  echo -e '\t\t\tcommand: curl -u ${REPO_USER} -X PUT ${REPO_URL} -T <BUILT_PACKAGE>.'
}

fexit() {
    echo "[!] ERROR: $1"
    echo ""
    exit 1
}

dir=""
data=""
repo=0
rem=0

params="$(getopt -o h -l help,no-repo,remove,dir:,data: --name "$0" -- "$@")"
eval set -- "${params}"

while [ $# -gt 0 ]; do
#echo "case $1"
  if [ "$1" != "--" ]; then
      case $1 in
        --dir)
          dir="$2"
          shift
          ;;
        --no-repo)
          repo=1
          ;;
        --remove)
          rem=1
          ;;
        -h|--help)
          showhelp
          exit 0
          ;;
        *)
          showhelp
          echo ""
          fexit "unknown parameter"
          ;;
      esac
  else
    break
  fi
  shift
done

[[ -z $(which R) ]] &&
    fexit "R needed but not found"
[[ -z ${dir} ]] && \
    fexit "dir parameter not present"

echo " - building package from ${dir}"
old_dir=$(realpath .)
cd ${dir}

# Test and build package
R -q -e "remotes::install_deps()"
R -q -e "devtools::document()" # || echo " - found docs problems"
R -q -e "devtools::check()" # || echo " - found test problems"
pkg=$(R -q -e "devtools::build()" | grep '\[1\]' | cut -d'"' -f2)

# Publish tar.gz to repository
if [[ ${repo} -eq 0 ]]; then
  [[ -z $(which curl) ]] && \
    fexit "curl needed but not found"
  [[ -z ${REPO_URL} || -z ${REPO_USER} ]] && \
    fexit "REPO_URL and REPO_USER missing" 
  echo " - publishing package to repository"
  curl -u ${REPO_USER} -X PUT ${REPO_URL} -T ${pkg}
fi

# Reinstall package
echo " - reinstalling ${pkg} locally"

if [[ ${rem} -eq 1 ]]; then
  R -q -e "remove.packages('$(basename ${dir})')" || echo " - pkg not present"
fi

R -q -e "install.packages(pkgs = '${pkg}', repos = NULL, type = 'source')" || \
  R -q -e "install.packages(pkgs = '${pkg}', lib = '~/R/x86_64-pc-linux-gnu-library', repos = NULL, type = 'source')"

cd ${old_dir}
