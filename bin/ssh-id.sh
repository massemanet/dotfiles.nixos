#!/usr/bin/env bash

shopt -s nullglob
for id in ~/.ssh/id_rsa_*.pub;
do ssh-add "${id%.*}"
done

bash
