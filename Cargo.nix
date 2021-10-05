
# This file was @generated by crate2nix 0.10.0 with the command:
#   "generate" "-f" "rust-app/Cargo.toml"
# See https://github.com/kolloch/crate2nix for more info.

{ nixpkgs ? <nixpkgs>
, pkgs ? import nixpkgs { config = {}; }
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
, buildRustCrateForPkgs ? pkgs: pkgs.buildRustCrate
  # This is used as the `crateOverrides` argument for `buildRustCrate`.
, defaultCrateOverrides ? pkgs.defaultCrateOverrides
  # The features to enable for the root_crate or the workspace_members.
, rootFeatures ? [ "default" ]
  # If true, throw errors instead of issueing deprecation warnings.
, strictDeprecation ? false
  # Used for conditional compilation based on CPU feature detection.
, targetFeatures ? []
  # Whether to perform release builds: longer compile times, faster binaries.
, release ? true
  # Additional crate2nix configuration if it exists.
, crateConfig
  ? if builtins.pathExists ./crate-config.nix
    then pkgs.callPackage ./crate-config.nix {}
    else {}
}:

rec {
  #
  # "public" attributes that we attempt to keep stable with new versions of crate2nix.
  #

  rootCrate = rec {
    packageId = "rust-app";

    # Use this attribute to refer to the derivation building your root crate package.
    # You can override the features with rootCrate.build.override { features = [ "default" "feature1" ... ]; }.
    build = internal.buildRustCrateWithFeatures {
      inherit packageId;
    };

    # Debug support which might change between releases.
    # File a bug if you depend on any for non-debug work!
    debug = internal.debugCrate { inherit packageId; };
  };
  # Refer your crate build derivation by name here.
  # You can override the features with
  # workspaceMembers."${crateName}".build.override { features = [ "default" "feature1" ... ]; }.
  workspaceMembers = {
    "rust-app" = rec {
      packageId = "rust-app";
      build = internal.buildRustCrateWithFeatures {
        packageId = "rust-app";
      };

      # Debug support which might change between releases.
      # File a bug if you depend on any for non-debug work!
      debug = internal.debugCrate { inherit packageId; };
    };
  };

  # A derivation that joins the outputs of all workspace members together.
  allWorkspaceMembers = pkgs.symlinkJoin {
      name = "all-workspace-members";
      paths =
        let members = builtins.attrValues workspaceMembers;
        in builtins.map (m: m.build) members;
  };

  #
  # "internal" ("private") attributes that may change in every new version of crate2nix.
  #

  internal = rec {
    # Build and dependency information for crates.
    # Many of the fields are passed one-to-one to buildRustCrate.
    #
    # Noteworthy:
    # * `dependencies`/`buildDependencies`: similar to the corresponding fields for buildRustCrate.
    #   but with additional information which is used during dependency/feature resolution.
    # * `resolvedDependencies`: the selected default features reported by cargo - only included for debugging.
    # * `devDependencies` as of now not used by `buildRustCrate` but used to
    #   inject test dependencies into the build

    crates = {
      "arrayvec" = rec {
        crateName = "arrayvec";
        version = "0.7.1";
        edition = "2018";
        sha256 = "1kcgsfp0ns0345g580ny7hhl9y9a6l3m0pykfa09p9pz65qw0kdy";
        authors = [
          "bluss"
        ];
        features = {
          "default" = [ "std" ];
        };
      };
      "autocfg" = rec {
        crateName = "autocfg";
        version = "1.0.1";
        edition = "2015";
        sha256 = "0jj6i9zn4gjl03kjvziqdji6rwx8ykz8zk2ngpc331z2g3fk3c6d";
        authors = [
          "Josh Stone <cuviper@gmail.com>"
        ];

      };
      "cc" = rec {
        crateName = "cc";
        version = "1.0.68";
        edition = "2018";
        crateBin = [];
        sha256 = "11ypa8b7iwhjf5fg5j3hvbn2116h9g8v67vyd9s7ljgzq52c4wja";
        authors = [
          "Alex Crichton <alex@alexcrichton.com>"
        ];
        features = {
          "parallel" = [ "jobserver" ];
        };
      };
      "cfg-if" = rec {
        crateName = "cfg-if";
        version = "1.0.0";
        edition = "2018";
        sha256 = "1za0vb97n4brpzpv8lsbnzmq5r8f2b0cpqqr0sy8h5bn751xxwds";
        authors = [
          "Alex Crichton <alex@alexcrichton.com>"
        ];
        features = {
          "rustc-dep-of-std" = [ "core" "compiler_builtins" ];
        };
      };
      "ctor" = rec {
        crateName = "ctor";
        version = "0.1.20";
        edition = "2018";
        sha256 = "0v80naiw5fp81xkyfkds6jpyamf3wx43kz4nif936bkq3any562y";
        procMacro = true;
        authors = [
          "Matt Mastracci <matthew@mastracci.com>"
        ];
        dependencies = [
          {
            name = "quote";
            packageId = "quote";
          }
          {
            name = "syn";
            packageId = "syn";
            usesDefaultFeatures = false;
            features = [ "full" "parsing" "printing" "proc-macro" ];
          }
        ];

      };
      "cty" = rec {
        crateName = "cty";
        version = "0.2.1";
        edition = "2015";
        sha256 = "1qvkdnkxmd7g6fwhmv26zxqi0l7b9cd4d7h1knylvjyh43bc04vk";
        authors = [
          "Jorge Aparicio <jorge@japaric.io>"
        ];

      };
      "generic-array" = rec {
        crateName = "generic-array";
        version = "0.14.4";
        edition = "2015";
        sha256 = "05qqwm9v5asbil9z28wjkmpfvs1c5c99n8n9gwxis3d3r3n6c52h";
        libName = "generic_array";
        authors = [
          "Bartłomiej Kamiński <fizyk20@gmail.com>"
          "Aaron Trent <novacrazy@gmail.com>"
        ];
        dependencies = [
          {
            name = "typenum";
            packageId = "typenum";
          }
        ];
        buildDependencies = [
          {
            name = "version_check";
            packageId = "version_check";
          }
        ];
        features = {
        };
      };
      "ledger-parser-combinators" = rec {
        crateName = "ledger-parser-combinators";
        version = "0.1.0";
        edition = "2018";
        workspace_member = null;
        src = pkgs.fetchgit {
          url = "https://github.com/obsidiansystems/ledger-parser-combinators";
          rev = "281b4877f6172a53506767112c3afac6eb470cf5";
          sha256 = "1831bidg1c8ic1mv6v0ivj4ap1ns2gbaikhcwrs8hwm2rxd72ml2";
        };
        authors = [
          "Jonathan D.K. Gibbons <jonored@gmail.com>"
        ];
        dependencies = [
          {
            name = "arrayvec";
            packageId = "arrayvec";
            usesDefaultFeatures = false;
          }
          {
            name = "generic-array";
            packageId = "generic-array";
            usesDefaultFeatures = false;
          }
          {
            name = "log";
            packageId = "log";
          }
        ];

      };
      "log" = rec {
        crateName = "log";
        version = "0.4.14";
        edition = "2015";
        sha256 = "04175hv0v62shd82qydq58a48k3bjijmk54v38zgqlbxqkkbpfai";
        authors = [
          "The Rust Project Developers"
        ];
        dependencies = [
          {
            name = "cfg-if";
            packageId = "cfg-if";
          }
          {
            name = "value-bag";
            packageId = "value-bag";
            optional = true;
            usesDefaultFeatures = false;
          }
        ];
        devDependencies = [
          {
            name = "value-bag";
            packageId = "value-bag";
            features = [ "test" ];
          }
        ];
        features = {
          "kv_unstable" = [ "value-bag" ];
          "kv_unstable_serde" = [ "kv_unstable_std" "value-bag/serde" "serde" ];
          "kv_unstable_std" = [ "std" "kv_unstable" "value-bag/error" ];
          "kv_unstable_sval" = [ "kv_unstable" "value-bag/sval" "sval" ];
        };
        resolvedDefaultFeatures = [ "kv_unstable" "value-bag" ];
      };
      "nanos_sdk" = rec {
        crateName = "nanos_sdk";
        version = "0.1.0";
        edition = "2018";
        workspace_member = null;
        src = pkgs.fetchgit {
          url = "https://github.com/ObsidianSystems/ledger-nanos-sdk.git";
          rev = "1b0d1a688713ffbf3956ebe9971584a79aec5560";
          sha256 = "09a7xyzdcr9n7m2gisirg7n8vqqg53i4rk92q293fw9ri5vrpj3d";
        };
        authors = [
          "yhql"
        ];
        dependencies = [
          {
            name = "cty";
            packageId = "cty";
          }
          {
            name = "num-traits";
            packageId = "num-traits";
            usesDefaultFeatures = false;
          }
        ];
        buildDependencies = [
          {
            name = "cc";
            packageId = "cc";
          }
        ];
        features = {
        };
        resolvedDefaultFeatures = [ "speculos" ];
      };
      "nanos_ui" = rec {
        crateName = "nanos_ui";
        version = "0.1.0";
        edition = "2018";
        workspace_member = null;
        src = pkgs.fetchgit {
          url = "https://github.com/LedgerHQ/ledger-nanos-ui.git";
          rev = "45777714fe567bc7dfe858d65fcf8495a3edc2e1";
          sha256 = "01697ci4j5arb0pz35pqpgk776rw1s5m3m06hkf0x4hcq7f9zn6y";
        };
        authors = [
          "yhql"
        ];
        dependencies = [
          {
            name = "nanos_sdk";
            packageId = "nanos_sdk";
          }
        ];

      };
      "num-traits" = rec {
        crateName = "num-traits";
        version = "0.2.14";
        edition = "2015";
        sha256 = "144j176s2p76azy2ngk2vkdzgwdc0bc8c93jhki8c9fsbknb2r4s";
        authors = [
          "The Rust Project Developers"
        ];
        buildDependencies = [
          {
            name = "autocfg";
            packageId = "autocfg";
          }
        ];
        features = {
          "default" = [ "std" ];
        };
      };
      "proc-macro2" = rec {
        crateName = "proc-macro2";
        version = "1.0.27";
        edition = "2018";
        sha256 = "0f3h0zl5w5090ajmmvpmhkpr4iwqnn5rip3afacabhc657vwmn7h";
        authors = [
          "Alex Crichton <alex@alexcrichton.com>"
          "David Tolnay <dtolnay@gmail.com>"
        ];
        dependencies = [
          {
            name = "unicode-xid";
            packageId = "unicode-xid";
          }
        ];
        features = {
          "default" = [ "proc-macro" ];
        };
        resolvedDefaultFeatures = [ "default" "proc-macro" ];
      };
      "quote" = rec {
        crateName = "quote";
        version = "1.0.9";
        edition = "2018";
        sha256 = "19rjmfqzk26rxbgxy5j2ckqc2v12sw2xw8l4gi8bzpn2bmsbkl63";
        authors = [
          "David Tolnay <dtolnay@gmail.com>"
        ];
        dependencies = [
          {
            name = "proc-macro2";
            packageId = "proc-macro2";
            usesDefaultFeatures = false;
          }
        ];
        features = {
          "default" = [ "proc-macro" ];
          "proc-macro" = [ "proc-macro2/proc-macro" ];
        };
        resolvedDefaultFeatures = [ "default" "proc-macro" ];
      };
      "rust-app" = rec {
        crateName = "rust-app";
        version = "0.2.0";
        edition = "2018";
        crateBin = [
          { name = "rust-app"; path = "src/main.rs"; }
        ];
        src = lib.cleanSourceWith { filter = sourceFilter;  src = ./rust-app; };
        authors = [
          "yhql"
        ];
        dependencies = [
          {
            name = "arrayvec";
            packageId = "arrayvec";
            usesDefaultFeatures = false;
          }
          {
            name = "ledger-parser-combinators";
            packageId = "ledger-parser-combinators";
          }
          {
            name = "nanos_sdk";
            packageId = "nanos_sdk";
            target = { target, features }: ((let p = stdenv.hostPlatform; in p.rustc.config or p.config) == "thumbv6m-none-eabi");
          }
          {
            name = "nanos_ui";
            packageId = "nanos_ui";
            target = { target, features }: ((let p = stdenv.hostPlatform; in p.rustc.config or p.config) == "thumbv6m-none-eabi");
          }
        ];
        devDependencies = [
          {
            name = "nanos_sdk";
            packageId = "nanos_sdk";
            target = {target, features}: ((let p = stdenv.hostPlatform; in p.rustc.config or p.config) == "thumbv6m-none-eabi");
            features = [ "speculos" ];
          }
          {
            name = "testmacro";
            packageId = "testmacro";
          }
        ];
        features = {
          "speculos" = [ "nanos_sdk/speculos" ];
        };
        resolvedDefaultFeatures = [ "speculos" ];
      };
      "syn" = rec {
        crateName = "syn";
        version = "1.0.73";
        edition = "2018";
        sha256 = "1ixw4lscc7009ibaic8g5bvnc94hdcr62ksjk3jjl38363zqj57p";
        authors = [
          "David Tolnay <dtolnay@gmail.com>"
        ];
        dependencies = [
          {
            name = "proc-macro2";
            packageId = "proc-macro2";
            usesDefaultFeatures = false;
          }
          {
            name = "quote";
            packageId = "quote";
            optional = true;
            usesDefaultFeatures = false;
          }
          {
            name = "unicode-xid";
            packageId = "unicode-xid";
          }
        ];
        features = {
          "default" = [ "derive" "parsing" "printing" "clone-impls" "proc-macro" ];
          "printing" = [ "quote" ];
          "proc-macro" = [ "proc-macro2/proc-macro" "quote/proc-macro" ];
          "test" = [ "syn-test-suite/all-features" ];
        };
        resolvedDefaultFeatures = [ "clone-impls" "default" "derive" "full" "parsing" "printing" "proc-macro" "quote" "visit" "visit-mut" ];
      };
      "testmacro" = rec {
        crateName = "testmacro";
        version = "0.1.0";
        edition = "2018";
        workspace_member = null;
        src = pkgs.fetchgit {
          url = "https://github.com/yhql/testmacro";
          rev = "29a16cb8718d61b67c6c391e60c8347c064e921e";
          sha256 = "0agl46ilx2psfvwvg8iwfmq203xapw435h03qskxqf5dnwhy1kir";
        };
        procMacro = true;
        authors = [
          "yhql <yhql@users.noreply.github.com>"
        ];
        dependencies = [
          {
            name = "quote";
            packageId = "quote";
          }
          {
            name = "syn";
            packageId = "syn";
            features = [ "full" ];
          }
        ];

      };
      "typenum" = rec {
        crateName = "typenum";
        version = "1.13.0";
        edition = "2018";
        sha256 = "01lbbspn4080yg8wp6y7q3xcqih1c1dmkkx4pwax4z1a9436k7w7";
        build = "build/main.rs";
        authors = [
          "Paho Lurie-Gregg <paho@paholg.com>"
          "Andre Bogus <bogusandre@gmail.com>"
        ];
        features = {
        };
      };
      "unicode-xid" = rec {
        crateName = "unicode-xid";
        version = "0.2.2";
        edition = "2015";
        sha256 = "1wrkgcw557v311dkdb6n2hrix9dm2qdsb1zpw7pn79l03zb85jwc";
        authors = [
          "erick.tryzelaar <erick.tryzelaar@gmail.com>"
          "kwantam <kwantam@gmail.com>"
          "Manish Goregaokar <manishsmail@gmail.com>"
        ];
        features = {
        };
        resolvedDefaultFeatures = [ "default" ];
      };
      "value-bag" = rec {
        crateName = "value-bag";
        version = "1.0.0-alpha.7";
        edition = "2018";
        sha256 = "1bj0v1sq0xvwmxcixvia08a9r1mdfr257xwn7qan2hpr40ahwcnx";
        authors = [
          "Ashley Mannix <ashleymannix@live.com.au>"
        ];
        dependencies = [
          {
            name = "ctor";
            packageId = "ctor";
          }
        ];
        buildDependencies = [
          {
            name = "version_check";
            packageId = "version_check";
            rename = "rustc";
          }
        ];
        features = {
          "error" = [ "std" "sval1_lib/std" ];
          "serde" = [ "serde1" ];
          "serde1" = [ "serde1_lib" "sval1_lib/serde1" "sval1_lib/alloc" "erased-serde1/alloc" "serde1_fmt" ];
          "sval" = [ "sval1" ];
          "sval1" = [ "sval1_lib" ];
          "test" = [ "std" ];
        };
      };
      "version_check" = rec {
        crateName = "version_check";
        version = "0.9.3";
        edition = "2015";
        sha256 = "1zmkcgj2m0pq0l4wnhrp1wl1lygf7x2h5p7pvjwc4719lnlxrv2z";
        authors = [
          "Sergio Benitez <sb@sergio.bz>"
        ];

      };
    };

    #
# crate2nix/default.nix (excerpt start)
#

  /* Target (platform) data for conditional dependencies.
    This corresponds roughly to what buildRustCrate is setting.
  */
  makeDefaultTarget = platform: {
    unix = platform.isUnix;
    windows = platform.isWindows;
    fuchsia = true;
    test = false;

    # This doesn't appear to be officially documented anywhere yet.
    # See https://github.com/rust-lang-nursery/rust-forge/issues/101.
    os =
      if platform.isDarwin
      then "macos"
      else platform.parsed.kernel.name;
    arch = platform.parsed.cpu.name;
    family = "unix";
    env = "gnu";
    endian =
      if platform.parsed.cpu.significantByte.name == "littleEndian"
      then "little" else "big";
    pointer_width = toString platform.parsed.cpu.bits;
    vendor = platform.parsed.vendor.name;
    debug_assertions = false;
  };

  /* Filters common temp files and build files. */
  # TODO(pkolloch): Substitute with gitignore filter
  sourceFilter = name: type:
    let
      baseName = builtins.baseNameOf (builtins.toString name);
    in
      ! (
        # Filter out git
        baseName == ".gitignore"
        || (type == "directory" && baseName == ".git")

        # Filter out build results
        || (
          type == "directory" && (
            baseName == "target"
            || baseName == "_site"
            || baseName == ".sass-cache"
            || baseName == ".jekyll-metadata"
            || baseName == "build-artifacts"
          )
        )

        # Filter out nix-build result symlinks
        || (
          type == "symlink" && lib.hasPrefix "result" baseName
        )

        # Filter out IDE config
        || (
          type == "directory" && (
            baseName == ".idea" || baseName == ".vscode"
          )
        ) || lib.hasSuffix ".iml" baseName

        # Filter out nix build files
        || baseName == "Cargo.nix"

        # Filter out editor backup / swap files.
        || lib.hasSuffix "~" baseName
        || builtins.match "^\\.sw[a-z]$$" baseName != null
        || builtins.match "^\\..*\\.sw[a-z]$$" baseName != null
        || lib.hasSuffix ".tmp" baseName
        || lib.hasSuffix ".bak" baseName
        || baseName == "tests.nix"
      );

  /* Returns a crate which depends on successful test execution
    of crate given as the second argument.

    testCrateFlags: list of flags to pass to the test exectuable
    testInputs: list of packages that should be available during test execution
  */
  crateWithTest = { crate, testCrate, testCrateFlags, testInputs, testPreRun, testPostRun }:
    assert builtins.typeOf testCrateFlags == "list";
    assert builtins.typeOf testInputs == "list";
    assert builtins.typeOf testPreRun == "string";
    assert builtins.typeOf testPostRun == "string";
    let
      # override the `crate` so that it will build and execute tests instead of
      # building the actual lib and bin targets We just have to pass `--test`
      # to rustc and it will do the right thing.  We execute the tests and copy
      # their log and the test executables to $out for later inspection.
      test =
        let
          drv = testCrate.override
            (
              _: {
                buildTests = true;
              }
            );
          # If the user hasn't set any pre/post commands, we don't want to
          # insert empty lines. This means that any existing users of crate2nix
          # don't get a spurious rebuild unless they set these explicitly.
          testCommand = pkgs.lib.concatStringsSep "\n"
            (pkgs.lib.filter (s: s != "") [
              testPreRun
              "$f $testCrateFlags 2>&1 | tee -a $out"
              testPostRun
            ]);
        in
        pkgs.runCommand "run-tests-${testCrate.name}"
          {
            inherit testCrateFlags;
            buildInputs = testInputs;
          } ''
          set -ex

          export RUST_BACKTRACE=1

          # recreate a file hierarchy as when running tests with cargo

          # the source for test data
          ${pkgs.xorg.lndir}/bin/lndir ${crate.src}

          # build outputs
          testRoot=target/debug
          mkdir -p $testRoot

          # executables of the crate
          # we copy to prevent std::env::current_exe() to resolve to a store location
          for i in ${crate}/bin/*; do
            cp "$i" "$testRoot"
          done
          chmod +w -R .

          # test harness executables are suffixed with a hash, like cargo does
          # this allows to prevent name collision with the main
          # executables of the crate
          hash=$(basename $out)
          for file in ${drv}/tests/*; do
            f=$testRoot/$(basename $file)-$hash
            cp $file $f
            ${testCommand}
          done
        '';
    in
    pkgs.runCommand "${crate.name}-linked"
      {
        inherit (crate) outputs crateName;
        passthru = (crate.passthru or { }) // {
          inherit test;
        };
      } ''
      echo tested by ${test}
      ${lib.concatMapStringsSep "\n" (output: "ln -s ${crate.${output}} ${"$"}${output}") crate.outputs}
    '';

  /* A restricted overridable version of builtRustCratesWithFeatures. */
  buildRustCrateWithFeatures =
    { packageId
    , features ? rootFeatures
    , crateOverrides ? defaultCrateOverrides
    , buildRustCrateForPkgsFunc ? null
    , runTests ? false
    , testCrateFlags ? [ ]
    , testInputs ? [ ]
      # Any command to run immediatelly before a test is executed.
    , testPreRun ? ""
      # Any command run immediatelly after a test is executed.
    , testPostRun ? ""
    }:
    lib.makeOverridable
      (
        { features
        , crateOverrides
        , runTests
        , testCrateFlags
        , testInputs
        , testPreRun
        , testPostRun
        }:
        let
          buildRustCrateForPkgsFuncOverriden =
            if buildRustCrateForPkgsFunc != null
            then buildRustCrateForPkgsFunc
            else
              (
                if crateOverrides == pkgs.defaultCrateOverrides
                then buildRustCrateForPkgs
                else
                  pkgs: (buildRustCrateForPkgs pkgs).override {
                    defaultCrateOverrides = crateOverrides;
                  }
              );
          builtRustCrates = builtRustCratesWithFeatures {
            inherit packageId features;
            buildRustCrateForPkgsFunc = buildRustCrateForPkgsFuncOverriden;
            runTests = false;
          };
          builtTestRustCrates = builtRustCratesWithFeatures {
            inherit packageId features;
            buildRustCrateForPkgsFunc = buildRustCrateForPkgsFuncOverriden;
            runTests = true;
          };
          drv = builtRustCrates.crates.${packageId};
          testDrv = builtTestRustCrates.crates.${packageId};
          derivation =
            if runTests then
              crateWithTest
                {
                  crate = drv;
                  testCrate = testDrv;
                  inherit testCrateFlags testInputs testPreRun testPostRun;
                }
            else drv;
        in
        derivation
      )
      { inherit features crateOverrides runTests testCrateFlags testInputs testPreRun testPostRun; };

  /* Returns an attr set with packageId mapped to the result of buildRustCrateForPkgsFunc
    for the corresponding crate.
  */
  builtRustCratesWithFeatures =
    { packageId
    , features
    , crateConfigs ? crates
    , buildRustCrateForPkgsFunc
    , runTests
    , makeTarget ? makeDefaultTarget
    } @ args:
      assert (builtins.isAttrs crateConfigs);
      assert (builtins.isString packageId);
      assert (builtins.isList features);
      assert (builtins.isAttrs (makeTarget stdenv.hostPlatform));
      assert (builtins.isBool runTests);
      let
        rootPackageId = packageId;
        mergedFeatures = mergePackageFeatures
          (
            args // {
              inherit rootPackageId;
              target = makeTarget stdenv.hostPlatform // { test = runTests; };
            }
          );
        # Memoize built packages so that reappearing packages are only built once.
        builtByPackageIdByPkgs = mkBuiltByPackageIdByPkgs pkgs;
        mkBuiltByPackageIdByPkgs = pkgs:
          let
            self = {
              crates = lib.mapAttrs (packageId: value: buildByPackageIdForPkgsImpl self pkgs packageId) crateConfigs;
              target = makeTarget pkgs.stdenv.hostPlatform;
              build = mkBuiltByPackageIdByPkgs pkgs.buildPackages;
            };
          in
          self;
        buildByPackageIdForPkgsImpl = self: pkgs: packageId:
          let
            features = mergedFeatures."${packageId}" or [ ];
            crateConfig' = crateConfigs."${packageId}";
            crateConfig =
              builtins.removeAttrs crateConfig' [ "resolvedDefaultFeatures" "devDependencies" ];
            devDependencies =
              lib.optionals
                (runTests && packageId == rootPackageId)
                (crateConfig'.devDependencies or [ ]);
            dependencies =
              dependencyDerivations {
                inherit features;
                inherit (self) target;
                buildByPackageId = depPackageId:
                  # proc_macro crates must be compiled for the build architecture
                  if crateConfigs.${depPackageId}.procMacro or false
                  then self.build.crates.${depPackageId}
                  else self.crates.${depPackageId};
                dependencies =
                  (crateConfig.dependencies or [ ])
                  ++ devDependencies;
              };
            buildDependencies =
              dependencyDerivations {
                inherit features;
                inherit (self.build) target;
                buildByPackageId = depPackageId:
                  self.build.crates.${depPackageId};
                dependencies = crateConfig.buildDependencies or [ ];
              };
            dependenciesWithRenames =
              lib.filter (d: d ? "rename")
                (filterEnabledDependencies {
                  inherit features;
                  inherit (self.build) target;
                  dependencies = crateConfig.buildDependencies or [ ];
                } ++ filterEnabledDependencies {
                  inherit features;
                  inherit (self) target;
                  dependencies = crateConfig.dependencies or [ ] ++ devDependencies;
                });
            # Crate renames have the form:
            #
            # {
            #    crate_name = [
            #       { version = "1.2.3"; rename = "crate_name01"; }
            #    ];
            #    # ...
            # }
            crateRenames =
              let
                grouped =
                  lib.groupBy
                    (dependency: dependency.name)
                    dependenciesWithRenames;
                versionAndRename = dep:
                  let
                    package = crateConfigs."${dep.packageId}";
                  in
                  { inherit (dep) rename; version = package.version; };
              in
              lib.mapAttrs (name: choices: builtins.map versionAndRename choices) grouped;
          in
          buildRustCrateForPkgsFunc pkgs
            (
              crateConfig // {
                src = crateConfig.src or (
                  pkgs.fetchurl rec {
                    name = "${crateConfig.crateName}-${crateConfig.version}.tar.gz";
                    # https://www.pietroalbini.org/blog/downloading-crates-io/
                    # Not rate-limited, CDN URL.
                    url = "https://static.crates.io/crates/${crateConfig.crateName}/${crateConfig.crateName}-${crateConfig.version}.crate";
                    sha256 =
                      assert (lib.assertMsg (crateConfig ? sha256) "Missing sha256 for ${name}");
                      crateConfig.sha256;
                  }
                );
                extraRustcOpts = lib.lists.optional (targetFeatures != [ ]) "-C target-feature=${lib.concatMapStringsSep "," (x: "+${x}") targetFeatures}";
                inherit features dependencies buildDependencies crateRenames release;
              }
            );
      in
      builtByPackageIdByPkgs;

  /* Returns the actual derivations for the given dependencies. */
  dependencyDerivations =
    { buildByPackageId
    , features
    , dependencies
    , target
    }:
      assert (builtins.isList features);
      assert (builtins.isList dependencies);
      assert (builtins.isAttrs target);
      let
        enabledDependencies = filterEnabledDependencies {
          inherit dependencies features target;
        };
        depDerivation = dependency: buildByPackageId dependency.packageId;
      in
      map depDerivation enabledDependencies;

  /* Returns a sanitized version of val with all values substituted that cannot
    be serialized as JSON.
  */
  sanitizeForJson = val:
    if builtins.isAttrs val
    then lib.mapAttrs (n: v: sanitizeForJson v) val
    else if builtins.isList val
    then builtins.map sanitizeForJson val
    else if builtins.isFunction val
    then "function"
    else val;

  /* Returns various tools to debug a crate. */
  debugCrate = { packageId, target ? makeDefaultTarget stdenv.hostPlatform }:
    assert (builtins.isString packageId);
    let
      debug = rec {
        # The built tree as passed to buildRustCrate.
        buildTree = buildRustCrateWithFeatures {
          buildRustCrateForPkgsFunc = _: lib.id;
          inherit packageId;
        };
        sanitizedBuildTree = sanitizeForJson buildTree;
        dependencyTree = sanitizeForJson
          (
            buildRustCrateWithFeatures {
              buildRustCrateForPkgsFunc = _: crate: {
                "01_crateName" = crate.crateName or false;
                "02_features" = crate.features or [ ];
                "03_dependencies" = crate.dependencies or [ ];
              };
              inherit packageId;
            }
          );
        mergedPackageFeatures = mergePackageFeatures {
          features = rootFeatures;
          inherit packageId target;
        };
        diffedDefaultPackageFeatures = diffDefaultPackageFeatures {
          inherit packageId target;
        };
      };
    in
    { internal = debug; };

  /* Returns differences between cargo default features and crate2nix default
    features.

    This is useful for verifying the feature resolution in crate2nix.
  */
  diffDefaultPackageFeatures =
    { crateConfigs ? crates
    , packageId
    , target
    }:
      assert (builtins.isAttrs crateConfigs);
      let
        prefixValues = prefix: lib.mapAttrs (n: v: { "${prefix}" = v; });
        mergedFeatures =
          prefixValues
            "crate2nix"
            (mergePackageFeatures { inherit crateConfigs packageId target; features = [ "default" ]; });
        configs = prefixValues "cargo" crateConfigs;
        combined = lib.foldAttrs (a: b: a // b) { } [ mergedFeatures configs ];
        onlyInCargo =
          builtins.attrNames
            (lib.filterAttrs (n: v: !(v ? "crate2nix") && (v ? "cargo")) combined);
        onlyInCrate2Nix =
          builtins.attrNames
            (lib.filterAttrs (n: v: (v ? "crate2nix") && !(v ? "cargo")) combined);
        differentFeatures = lib.filterAttrs
          (
            n: v:
              (v ? "crate2nix")
              && (v ? "cargo")
              && (v.crate2nix.features or [ ]) != (v."cargo".resolved_default_features or [ ])
          )
          combined;
      in
      builtins.toJSON {
        inherit onlyInCargo onlyInCrate2Nix differentFeatures;
      };

  /* Returns an attrset mapping packageId to the list of enabled features.

    If multiple paths to a dependency enable different features, the
    corresponding feature sets are merged. Features in rust are additive.
  */
  mergePackageFeatures =
    { crateConfigs ? crates
    , packageId
    , rootPackageId ? packageId
    , features ? rootFeatures
    , dependencyPath ? [ crates.${packageId}.crateName ]
    , featuresByPackageId ? { }
    , target
      # Adds devDependencies to the crate with rootPackageId.
    , runTests ? false
    , ...
    } @ args:
      assert (builtins.isAttrs crateConfigs);
      assert (builtins.isString packageId);
      assert (builtins.isString rootPackageId);
      assert (builtins.isList features);
      assert (builtins.isList dependencyPath);
      assert (builtins.isAttrs featuresByPackageId);
      assert (builtins.isAttrs target);
      assert (builtins.isBool runTests);
      let
        crateConfig = crateConfigs."${packageId}" or (builtins.throw "Package not found: ${packageId}");
        expandedFeatures = expandFeatures (crateConfig.features or { }) features;
        enabledFeatures = enableFeatures (crateConfig.dependencies or [ ]) expandedFeatures;
        depWithResolvedFeatures = dependency:
          let
            packageId = dependency.packageId;
            features = dependencyFeatures enabledFeatures dependency;
          in
          { inherit packageId features; };
        resolveDependencies = cache: path: dependencies:
          assert (builtins.isAttrs cache);
          assert (builtins.isList dependencies);
          let
            enabledDependencies = filterEnabledDependencies {
              inherit dependencies target;
              features = enabledFeatures;
            };
            directDependencies = map depWithResolvedFeatures enabledDependencies;
            foldOverCache = op: lib.foldl op cache directDependencies;
          in
          foldOverCache
            (
              cache: { packageId, features }:
                let
                  cacheFeatures = cache.${packageId} or [ ];
                  combinedFeatures = sortedUnique (cacheFeatures ++ features);
                in
                if cache ? ${packageId} && cache.${packageId} == combinedFeatures
                then cache
                else
                  mergePackageFeatures {
                    features = combinedFeatures;
                    featuresByPackageId = cache;
                    inherit crateConfigs packageId target runTests rootPackageId;
                  }
            );
        cacheWithSelf =
          let
            cacheFeatures = featuresByPackageId.${packageId} or [ ];
            combinedFeatures = sortedUnique (cacheFeatures ++ enabledFeatures);
          in
          featuresByPackageId // {
            "${packageId}" = combinedFeatures;
          };
        cacheWithDependencies =
          resolveDependencies cacheWithSelf "dep"
            (
              crateConfig.dependencies or [ ]
              ++ lib.optionals
                (runTests && packageId == rootPackageId)
                (crateConfig.devDependencies or [ ])
            );
        cacheWithAll =
          resolveDependencies
            cacheWithDependencies "build"
            (crateConfig.buildDependencies or [ ]);
      in
      cacheWithAll;

  /* Returns the enabled dependencies given the enabled features. */
  filterEnabledDependencies = { dependencies, features, target }:
    assert (builtins.isList dependencies);
    assert (builtins.isList features);
    assert (builtins.isAttrs target);

    lib.filter
      (
        dep:
        let
          targetFunc = dep.target or (features: true);
        in
        targetFunc { inherit features target; }
        && (
          !(dep.optional or false)
          || builtins.any (doesFeatureEnableDependency dep) features
        )
      )
      dependencies;

  /* Returns whether the given feature should enable the given dependency. */
  doesFeatureEnableDependency = { name, rename ? null, ... }: feature:
    let
      prefix = "${name}/";
      len = builtins.stringLength prefix;
      startsWithPrefix = builtins.substring 0 len feature == prefix;
    in
    (rename == null && feature == name)
    || (rename != null && rename == feature)
    || startsWithPrefix;

  /* Returns the expanded features for the given inputFeatures by applying the
    rules in featureMap.

    featureMap is an attribute set which maps feature names to lists of further
    feature names to enable in case this feature is selected.
  */
  expandFeatures = featureMap: inputFeatures:
    assert (builtins.isAttrs featureMap);
    assert (builtins.isList inputFeatures);
    let
      expandFeature = feature:
        assert (builtins.isString feature);
        [ feature ] ++ (expandFeatures featureMap (featureMap."${feature}" or [ ]));
      outFeatures = lib.concatMap expandFeature inputFeatures;
    in
    sortedUnique outFeatures;

  /* This function adds optional dependencies as features if they are enabled
    indirectly by dependency features. This function mimics Cargo's behavior
    described in a note at:
    https://doc.rust-lang.org/nightly/cargo/reference/features.html#dependency-features
  */
  enableFeatures = dependencies: features:
    assert (builtins.isList features);
    assert (builtins.isList dependencies);
    let
      additionalFeatures = lib.concatMap
        (
          dependency:
            assert (builtins.isAttrs dependency);
            let
              enabled = builtins.any (doesFeatureEnableDependency dependency) features;
            in
            if (dependency.optional or false) && enabled then [ dependency.name ] else [ ]
        )
        dependencies;
    in
    sortedUnique (features ++ additionalFeatures);

  /*
    Returns the actual features for the given dependency.

    features: The features of the crate that refers this dependency.
  */
  dependencyFeatures = features: dependency:
    assert (builtins.isList features);
    assert (builtins.isAttrs dependency);
    let
      defaultOrNil =
        if dependency.usesDefaultFeatures or true
        then [ "default" ]
        else [ ];
      explicitFeatures = dependency.features or [ ];
      additionalDependencyFeatures =
        let
          dependencyPrefix = (dependency.rename or dependency.name) + "/";
          dependencyFeatures =
            builtins.filter (f: lib.hasPrefix dependencyPrefix f) features;
        in
        builtins.map (lib.removePrefix dependencyPrefix) dependencyFeatures;
    in
    defaultOrNil ++ explicitFeatures ++ additionalDependencyFeatures;

  /* Sorts and removes duplicates from a list of strings. */
  sortedUnique = features:
    assert (builtins.isList features);
    assert (builtins.all builtins.isString features);
    let
      outFeaturesSet = lib.foldl (set: feature: set // { "${feature}" = 1; }) { } features;
      outFeaturesUnique = builtins.attrNames outFeaturesSet;
    in
    builtins.sort (a: b: a < b) outFeaturesUnique;

  deprecationWarning = message: value:
    if strictDeprecation
    then builtins.throw "strictDeprecation enabled, aborting: ${message}"
    else builtins.trace message value;

  #
  # crate2nix/default.nix (excerpt end)
  #
  };
}

