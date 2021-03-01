#!/bin/env bash

# gen_html.sh
#
# Author: Zaszi - admin@zaszi.net
#
# A generator script to convert one or more Github-Flavored Markdown files
# to HTML using Pandoc.
#
# Source:
# https://learnbyexample.github.io/customizing-pandoc/
#
# Requirements:
# - pandoc 2.10.1 or above
# - texlive-most
# - texlive-latexextra
#
# Usage: ./gen_html.sh <input_dir>/

# DEBUG
# set -o xtrace

set -o nounset
set -o pipefail
set -o errexit

main() {
    mkdir -p "$1/html"

    for filename in "$1"*.md; do
        name=$(basename "$filename" | sed 's/\.md//')

        pandoc "$filename" \
            --from gfm \
            --include-in-header ~/.bin/snippets/pandoc.css \
            --lua-filter ~/.bin/snippets/links-to-html.lua \
            --highlight-style ~/.bin/snippets/pygments.theme \
            --standalone \
            --output "${1}/html/${name}.html"
    done
}

main "$@"
