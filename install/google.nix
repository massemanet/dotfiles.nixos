{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
 name = "google-env";
 targetPkgs = pkgs: (with pkgs;
  [
    autoconf
    automake
    bash-completion
    bazel
    binutils
    docker
    git
    glibcLocales
    go
    gradle
    libyaml
    maven
    openjdk
    python2
    python3
  ]);
 multiPkgs = pkgs: (with pkgs;
  [
    glibc
    glibc.static
    gcc
    stdenv.cc.cc.lib
    gcc.cc
    zlib
  ]);
  runScript = "ssh-agent ~/bin/wg2.sh";
}).env
