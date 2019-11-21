{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
 name = "erlang-env";
 targetPkgs = pkgs: (with pkgs;
  [
    autoconf
    automake
    bash-completion
    binutils
    coreutils-full
    curl
    gcc
    git
    glibcLocales
    lksctp-tools
    lsof
    lttng-tools
    lttng-ust
    ncurses
    openssl
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
with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "my-app";
  src = ./.;

  buildInputs = [ boost poco ];

  buildPhase = "c++ -o main main.cpp -lPocoFoundation -lboost_system";

  installPhase = ''
    mkdir -p $out/bin
    cp main $out/bin/
  '';
}