# Provenance Ledger app

An [Ledger](https://www.ledger.com/) application for the [Provenance Blockchain](https://provenance.io/).

## Device Compatability

This application is compatible with
- Ledger Nano S, running firmware 2.1.0 and above
- Ledger Nano S+, running firmware 1.0.3
- Ledger Nano X

Note: Compatibility with Ledger Nano X is only possible to check on [Speculos](https://github.com/ledgerHQ/speculos/) emulator,
because the Nano X does not support side-loading apps under development.

## Installing the app

If you don't want to develop the app but just use it, installation should be very simple.
The first step is to obtain a release tarball.
The second step is to load that app from the tarball.

### Obtaining a release tarball

#### Download an official build

Check the [releases page](https://github.com/obsidiansystems/provenance/releases) of this app to see if an official build has been uploaded for this release.
There is a separate tarball for each device.

#### Build one yourself, with Nix

There is a separate tarball for each device.
To build one, run:
```bash
nix-build -A $DEVICE.tarball
```
where `DEVICE` is one of
 - `nanos`, for Nano S
 - `nanox`, for Nano X
 - `nanosplus`, for Nano S+

The last line printed out will be the path of the tarball.

### Installation using the pre-packaged tarball

Before installing please ensure that your device is plugged, unlocked, and on the device home screen.
Installing the app from a tarball can be done using [`ledgerctl`](https://github.com/ledgerHQ/ledgerctl).

#### With Nix

By using Nix, this can be done simply by using the `load-app` command, without manually installing the `ledgerctl` on your system.

```bash
tar xzf release.tar.gz
cd rust-app
nix-shell
load-app
```

#### Without Nix

Without using Nix, the `ledgerctl` can be used directly to install the app with the following commands.
For more information on how to install and use that tool see the [instructions from LedgerHQ](https://github.com/LedgerHQ/ledgerctl).

```bash
tar xzf release.tar.gz
cd rust-app
ledgerctl install -f app.json
```

## Using the app with generic CLI tool

The bundled `generic-cli` tool can be used to obtaining the public key and do signing.

To use this tool using Nix, from the root level of this repo, run this command to enter a shell with all the tools you'll need:
```bash
nix-shell -A $DEVICE.appShell
```
where `DEVICE` is one of
 - `nanos`, for Nano S
 - `nanox`, for Nano X
 - `nanosplus`, for Nano S+

Then, one can use `generic-cli` like this:

- Get a public key for a BIP-32 derivation:
  ```shell-session
  $ generic-cli getAddress "44'/535348'/0'/0/0"
  a42e71c004770d1a48956090248a8d7d86ee02726b5aab2a5cd15ca9f57cbd71
  ```

- Sign a transaction:
  ```shell-session
  $ generic-cli sign "44'/535348'/0'/0/0" '1f412f225311f589eb3ea8fd05d3de9e1f412f225311f589eb3ea8fd05d3de9e1f412f225311f589eb3ea8fd05d3de9ef8f206a1250bf53321699f4213e7a4f6'
  Signing:  <Buffer 1f 41 2f 22 53 11 f5 89 eb 3e a8 fd 05 d3 de 9e 1f 41 2f 22 53 11 f5 89 eb 3e a8 fd 05 d3 de 9e 1f 41 2f 22 53 11 f5 89 eb 3e a8 fd 05 d3 de 9e f8 f2 ... 14 more bytes>
  906a1d402aa17b32e96903b1a42ba0df9b690157e6b9a974a36b81ee023a7e6bd39eeaa40cab270e6451dff4d820044c982bfd12a6fa88c0f5b758c0d8b67201
  ```

The exact output you see will vary, since Ledger devices should not be configured to have the same private key!

## Development

See [CONTRIBUTING.md](./CONTRIBUTING.md).
