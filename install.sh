#!/usr/bin/env bash

mkdir $HOME/.config/cph/
cp $(pwd)/template.* $HOME/.config/cph/
ln -s $(pwd)/cph /usr/local/bin/cph
