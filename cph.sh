#!/usr/bin/env bash

program_name="cph";
path=$(pwd);
name="";
name_define="";
author=$(whoami);
source_file_name="";
header_file_name="";
template_dir="$HOME/.config/cph";
template_source="$template_dir/template.c";
template_header="$template_dir/template.h";


function print_usage() {
    cat << EOF
Usage:  ${program_name} [OPTION]

C Programming Helper helps to create C projects or files using the templates specified in "\$(HOME)/.config/cph".

-p, --project [NAME]        create project specified called [NAME]
-f, --files [NAME]          create source and header files called [NAME].{c,h}
-s, --source [NAME]
-h, --header [NAME]
-h, --help                  display this help message

EOF

}

function create_header_default() {
  echo "Not yet implemented";
}

function create_source_default() {
  echo "Not yet implemented";
}


function get_path() {
  if (( $# < 3 )); then
    path=$(pwd);
  else
    path=$3;
  fi
}

function create_source() {
  source_file_name=$2.c;
  get_path "$@";

  if [[ ! -e "$template_source" ]]; then
    create_source_default "$@";
  else
    cat $template_source >> $path/$source_file_name;
    sed -i -e "s/__FILE_NAME__/$name/g" $path/$source_file_name;
    sed -i -e "s/__AUTHOR__/$author/g" $path/$source_file_name;
  fi
}

function create_header() {
  header_file_name=$2.h;
  get_path "$@";
  name_define=$(echo $name | perl -ne 'print uc');
  name_define="${name_define}_H";

  if [[ ! -e "$template_header" ]]; then
    create_header_default "$@";
  else
    cat $template_header >> $path/$header_file_name;
    sed -i -e "s/__FILE_NAME__/$name/g" $path/$header_file_name;
    sed -i -e "s/__FILE_NAME_DEFINE__/$name_define/g" $path/$header_file_name;
    sed -i -e "s/__AUTHOR__/$author/g" $path/$header_file_name;
  fi
}


function parse_params() {
  # if no param is passed we print help
  if (( $# == 0 )); then
    print_usage;
  fi

  while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
    -h | --help )
      print_usage;
      exit;
      ;;
    -f | --files )
      name=$2;
      create_source "$@";
      create_header "$@";
      exit;
      ;;
    -s | --source )
      name=$2;
      create_source "$@";
      exit;
      ;;
    -i | --header )
      name=$2;
      create_header "$@";
      exit;
      ;;
    * )
      print_usage
      ;;
  esac; shift; done
  if [[ "$1" == '--' ]]; then shift; fi
}


function main() {
  parse_params "$@"
  exit;
}

main "$@"
