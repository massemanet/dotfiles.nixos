#!/usr/bin/env bash

shopt -s nullglob
for id in ~/.ssh/id_rsa_*.pub;
do ssh-add "${id%.*}"
done

cd "$HOME/git/loltel" || exit
git config --local user.email "masse@wgtwo.com"
git config --local github.user "masse-wg2"

bash
