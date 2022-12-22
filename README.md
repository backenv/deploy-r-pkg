# `deployRpkg`

## Deploy R packages with one command

```bash

$ deployRpkg.sh --help
[?] Usage: /usr/bin/deployRpkg --dir <PATH> [--no-repo --remove]
----------------------------------------------
[+]	--dir: R package folder
[+]	--no-repo: Skip publishing to private repository
[+]	--remove: Remove package before installation
[+]	-h|--help: Show this help
[+] NOTES:
		- Needs R and devtools + testthat packages
		- Repository upload requires curl and to set
			REPO_URL and REPO_USER environment variables.
			command: curl -u ${REPO_USER} -X PUT ${REPO_URL} -T <BUILT_PACKAGE>.
```

### Docker usage

Container images can be found at [Docker Hub](https://hub.docker.com/r/burgeonenv/deploy-r-pkg)

```bash
$ docker build -t deploy-r-pkg burgeonenv/deploy-r-pkg:base
$ docker run -v /path/to/package:/deploy/pkg deploy-r-pkg deployRpkg --dir . --no-repo
```

### `extras` folder

Contains Dockerfiles for extended images so dependencies installation time can be avoided. Each entry corresponds with a TAG

*sql*
 - `bcrypt`
 - `DBI`
 - `RSQLite`
 - `stringi`
 - `uuid`

*plumber*
 - `jsonlite`
 - `future`
 - `plumber (>= 1.0.0)`
 - `promises`
 - `stringi`
 - `tools`

*shiny*
 - `DT`
 - `jsonlite`
 - `future`
 - `ggplot2`
 - `htmlTable`
 - `htmltools`
 - `promises`
 - `semantic.dashboard`
 - `shiny`
 - `shinyjs`
 - `shiny.semantic`
 - `stringi`

