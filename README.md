# Scripts

Zaszi's collection of scripts.

## Usage

This repository contains a collection of small scripts and snippets of code.
While most of these are in-use and maintained, they usually aren't significant
enough to merit their own repository and thus find their place here.

- `bin/` contains the scripts.
- `snippets/` contains snippets which are usually called or otherwise used within scripts. This directory is espected to be in the same location as the scripts themselves.

I deploy these files to my machines using [Ansible](https://www.ansible.com/) (my Ansible dotfiles role can be found [here](https://github.com/zaszi/ansible-role-dotfiles)).

## Features

### gen_html.sh

A Bash script invoking Pandoc in order to convert one or more GitHub-Flavored-Markdown files to HTML.

### gen_pdf.sh

A Bash script invoking Pandoc in order to convert one or more GitHub-Flavored-Markdown files to PDF.

### wake_shale.sh

A Bash script to Wake-On-LAN a specific host named shale. The call is relayed through a bastion server, named galena.

## Contribution

Found a problem or have a suggestion? Feel free to open an issue.

## License

Scripts is licensed under the [MIT license](LICENSE).
