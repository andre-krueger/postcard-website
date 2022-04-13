[Install nix](https://nixos.org/download.html) if it isn't available yet.

Run `nix develop` to enter a dev shell and then run `nixos-shell --flake .#vm` to start a virtual machine that contains a configuration
to run the backend. After the VM is started and you are required to login (enter username `root` with an empty password to login), the website is available under [https://localhost:8081](https://localhost:8081) on the host.

The dev server for the admin dashboard can be started by `yarn start:admin`.

The dev server for the website frontend can be started by `yarn start:website`.

To run and recompile the backend on each change, run `cargo watch -x "run"`.
