FROM burgeonenv/deploy-r-pkg:base

ENV R_PKGS="DT jsonlite future ggplot2 htmlTable htmltools promises semantic.dashboard shiny shinyjs shiny.semantic stringi"

RUN for p in ${R_PKGS}; do R -q -e "if (! '${p}' %in% rownames(installed.packages())) install.packages('${p}')"; done
