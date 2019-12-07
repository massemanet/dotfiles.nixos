{ pkgs ? import <nixpkgs> {} }:

let
  hcl = pkgs.python37Packages.buildPythonPackage rec {
    pname = "pyhcl";
    version = "0.3.9";

    src = pkgs.python37Packages.fetchPypi {
      inherit pname version;
      sha256 = "08qjb228cznan8q8wvvj6pl0mnv59cmcv7jhf27d9xh6mr31pnhb";
    };
    buildInputs = [
      pkgs.python
      pkgs.git
    ];
    preConfigure = ''
      echo "ply==3.*" > requirements.txt
    '';
    propagatedBuildInputs = [ pkgs.python37Packages.ply ];
  };

  slacker = pkgs.python37Packages.buildPythonPackage rec {
    pname = "slacker";
    version = "0.9.60";
    src = pkgs.python37Packages.fetchPypi {
      inherit pname version;
      sha256 = "1jzqqxg9s65rfxyp8wia687cydj4xmm13kc27kzzmijn3459am2x";
    };
    propagatedBuildInputs = [ pkgs.python37Packages.requests ];
    doCheck = false;
  };

in

(pkgs.buildFHSUserEnv {
 name = "wg2-env";
 targetPkgs = pkgs: (with pkgs;
  [
    autoconf
    automake
    aws-vault
    awscli
    bash-completion
    bazel
    bazelisk
    binutils
    docker
    docker_compose
    erlangR22
    git
    glibcLocales
    go
    gopass
    gradle
    kubectl
    libpcap
    lksctp-tools
    lttng-ust
    maven
    openjdk
    pgadmin
    python2 (python3.withPackages (ps: [ps.semver ps.pyyaml slacker hcl ]))
    rebar3
    socat
    python3
    tshark
    wireshark
  ]);
 multiPkgs = pkgs: (with pkgs;
  [
    glibc
    gcc
    stdenv.cc.cc.lib
    gcc.cc
    zlib
  ]);
  runScript = "ssh-agent ~/bin/wg2.sh";
}).env
