#!/bin/sh

[ $# -ne 1 ] && echo "Usage: $(basename "$0") <prog>" >&2 && exit 1
file="$1"

[ ! -e "${file}" ] && echo "$(basename "$0"): file ${file} does not exist" >&2 && exit 1

name="$(awk 'NR==1{print $2}' "${file}")"
description="$(grep -A1 '^\.SH NAME' "${file}" | awk 'NR==2{print}')"
section="$(awk 'NR==1{print $3}' "${file}")"

#echo "${name} (${section}) : ${description}" >&2

groff -mandoc -Thtml "${file}" | sed \
   -e '/<!DOCTYPE[^$]\+$/d' \
   -e '/"http:[^$]\+$/d' \
   -e '1,19d' \
   -e "s/<h1 align=\"center\">${name}/<h1>${name} (${section})/" \
   -e '/^<\/body>$/d' \
   -e '/^<\/html>$/d' \
   -e 's/<p/<p class="bcc-p"/g' \
   -e 's/<pre/<pre class="bcc-pre"/g' \
   -e 's/<h2/<h2 class="bcc-h2"/g' \
   -e 's/<hr>/<hr class="bcc-hr">/g' \
   -e 's/<a/<a class="bcc-a"/g' | sed \
   -e '3i<table width="100%"><tr><td width="80%">' \
   -e '12i<\/td><td>' \
   -e '12i<a align="center" class="bcc-link" target="_blank" href="https://github.com/Benni3D/microcoreutils">GitHub<\/a>' \
   -e '12i<\/td><\/tr><\/table>' \
   -e "\$a<p class=\"unimp\">Generated using groff on $(date -u +"%F %T (UTC)")</p>"