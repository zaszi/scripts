#!/bin/env bash

# gen_pdf.sh
#
# Author: Zaszi - admin@zaszi.net
#
# A generator script to convert a Github-Flavored Markdown file to PDF using
# Pandoc.
#
# Source:
# https://learnbyexample.github.io/customizing-pandoc/
#
# Requirements:
# - pandoc 2.10.1 or above
# - texlive-most
# - texlive-latexextra
#
# Usage: ./gen_pdf.sh <input_file>.md <input_file>.md <output_file>.pdf

# DEBUG
# set -o xtrace

set -o nounset
set -o pipefail
set -o errexit

main() {
    # Retrieve all but the last argument.
    args=${*%${!#}}

    # Don't quote the variable so proper word splitting is used.
    # shellcheck disable=SC2086
    pandoc $args \
        --from gfm \
        --include-in-header ~/.bin/snippets/chapter_break.tex \
        --include-in-header ~/.bin/snippets/inline_code.tex \
        --include-in-header ~/.bin/snippets/bullet_style.tex \
        --highlight-style ~/.bin/snippets/pygments.theme \
        --variable=linkcolor:blue \
        --variable=geometry:a4paper \
        --variable=geometry:margin=2cm \
        --variable=mainfont="Droid Serif" \
        --variable=monofont="Iosevka Term Nerd Font Complete" \
        --variable=fontsize=10pt \
        --standalone \
        --pdf-engine=xelatex \
        --output "${!#}"
}

main "$@"
