rec {
  alamgu = import ./dep/alamgu {};

  cosmos-sdk = alamgu.thunkSource ./dep/cosmos-sdk;

  inherit (alamgu)
    lib
    pkgs ledgerPkgs
    crate2nix
    buildRustCrateForPkgsLedger
    buildRustCrateForPkgsWrapper
    ;

  protobufOverrides = pkgs: attrs: {
    COSMOS_SDK = cosmos-sdk;
    PROTO_INCLUDE = "${pkgs.buildPackages.protobuf}/include";
    nativeBuildInputs = (attrs.nativeBuildInputs or []) ++ (with pkgs.buildPackages; [
      protobuf buf
    ]);
    buildInputs = (attrs.buildInputs or []) ++ [ cosmos-sdk ];
  };

  makeApp = { rootFeatures ? [ "default" ], release ? true }: import ./Cargo.nix {
    inherit rootFeatures release;
    pkgs = ledgerPkgs;
    buildRustCrateForPkgs = pkgs: let
      fun = buildRustCrateForPkgsWrapper
        pkgs
        ((buildRustCrateForPkgsLedger pkgs).override {
          defaultCrateOverrides = pkgs.defaultCrateOverrides // {
            rust-app = attrs: let
              sdk = lib.findFirst (p: lib.hasPrefix "rust_nanos_sdk" p.name) (builtins.throw "no sdk!") attrs.dependencies;
            in protobufOverrides pkgs attrs // {
              preHook = alamgu.gccLibsPreHook;
              extraRustcOpts = attrs.extraRustcOpts or [] ++ [
                "-C" "link-arg=-T${sdk.lib}/lib/nanos_sdk.out/script.ld"
                "-C" "linker=${pkgs.stdenv.cc.targetPrefix}clang"
              ];
            };
          };
        });
    in
      args: fun (args // lib.optionalAttrs pkgs.stdenv.hostPlatform.isAarch32 {
        dependencies = map (d: d // { stdlib = true; }) [
          alamgu.ledgerCore
          alamgu.ledgerCompilerBuiltins
        ] ++ args.dependencies;
      });
  };

  rustShell = alamgu.rustShell.overrideAttrs (protobufOverrides alamgu.ledgerPkgs);

  app = makeApp {};
  app-with-logging = makeApp {
    release = false;
    rootFeatures = [ "default" "speculos" "extra_debug" ];
  };

  # For CI
  rootCrate = app.rootCrate.build;
  rootCrate-with-logging = app-with-logging.rootCrate.build;

  tarSrc = ledgerPkgs.runCommandCC "tarSrc" {
    nativeBuildInputs = [
      alamgu.cargo-ledger
      alamgu.ledgerRustPlatform.rust.cargo
    ];
  } (alamgu.cargoLedgerPreHook + ''

    cp ${./rust-app/Cargo.toml} ./Cargo.toml
    # So cargo knows it's a binary
    mkdir src
    touch src/main.rs

    cargo-ledger --use-prebuilt ${rootCrate}/bin/rust-app --hex-next-to-json

    mkdir -p $out/rust-app
    cp app.json app.hex $out/rust-app
    cp ${./tarball-default.nix} $out/rust-app/default.nix
    cp ${./tarball-shell.nix} $out/rust-app/shell.nix
    cp ${./rust-app/crab.gif} $out/rust-app/crab.gif
  '');

  tarball = pkgs.runCommandNoCC "app-tarball.tar.gz" { } ''
    tar -czvhf $out -C ${tarSrc} rust-app
  '';

  loadApp = pkgs.writeScriptBin "load-app" ''
    #!/usr/bin/env bash
    cd ${tarSrc}/rust-app
    ${alamgu.ledgerctl}/bin/ledgerctl install -f ${tarSrc}/rust-app/app.json
  '';

  testPackage = (import ./ts-tests/override.nix { inherit pkgs; }).package;

  testScript = pkgs.writeShellScriptBin "mocha-wrapper" ''
    cd ${testPackage}/lib/node_modules/*/
    export NO_UPDATE_NOTIFIER=true
    exec ${pkgs.nodejs-14_x}/bin/npm --offline test -- "$@"
  '';

  runTests = { appExe ? rootCrate + "/bin/rust-app" }: pkgs.runCommandNoCC "run-tests" {
    nativeBuildInputs = [
      pkgs.wget alamgu.speculos.speculos testScript
    ];
  } ''
    RUST_APP=${rootCrate}/bin/*
    echo RUST APP IS $RUST_APP
    # speculos -k 2.0 $RUST_APP --display headless &
    mkdir $out
    (
    speculos -k 2.0 ${appExe} --display headless &
    SPECULOS=$!

    until wget -O/dev/null -o/dev/null http://localhost:5000; do sleep 0.1; done;

    ${testScript}/bin/mocha-wrapper
    rv=$?
    kill -9 $SPECULOS
    exit $rv) | tee $out/short |& tee $out/full
    rv=$?
    cat $out/short
    exit $rv
  '';

  test-with-loging = runTests {
    appExe = rootCrate-with-logging + "/bin/rust-app";
  };
  test = runTests {
    appExe = rootCrate + "/bin/rust-app";
  };

  inherit (pkgs.nodePackages) node2nix;

  appShell = pkgs.mkShell {
    packages = [ loadApp alamgu.generic-cli pkgs.jq ];
  };

  provenanced = pkgs.stdenv.mkDerivation {
    name = "provenance-bin";
    src = builtins.fetchurl {
      # url = "https://github.com/provenance-io/provenance/releases/download/v1.12.0/provenance-linux-amd64-v1.12.0.zip";
      url = "https://github.com/provenance-io/provenance/releases/download/v1.11.1/provenance-linux-amd64-v1.11.1.zip";
      # sha256="0bj8ay1vxplx5l9w19vwgv254s60c804zx11h9jlk0lvd6rz2xa0";
      sha256="0afznyw7gh4h8sswdw8b7bjc6594vgi4ldzv74cy4mk1sgjib4h4";
    };
    buildInputs = [ pkgs.leveldb ];
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    unpackPhase = ":";
    buildPhase = ":";
    installPhase = ''
      mkdir $out
      cd $out
      ${pkgs.unzip}/bin/unzip $src
    '';
  };
}
