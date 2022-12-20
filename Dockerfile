FROM r-base:latest

RUN R -q -e "install.packages('devtools');install.packages('testthat')"

COPY deployRpkg.sh /usr/bin/deployRpkg
RUN chmod +x /usr/bin/deployRpkg

CMD "/usr/bin/deployRpkg --dir $1"
