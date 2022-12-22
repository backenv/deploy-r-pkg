FROM burgeonenv/deploy-r-pkg:base

ENV R_PKGS="bcrypt DBI RSQLite stringi uuid"

RUN for p in ${R_PKGS}; do R -q -e "if (! '${p}' %in% rownames(installed.packages())) install.packages('${p}')"; done
