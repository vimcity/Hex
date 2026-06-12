# Hex Personal

Personal Hex fork for local voice dictation on macOS.

## Install

Build and install app to `~/Applications/Hex Personal.app`:

```bash
./dev/install-personal.sh
```

Optional custom identity:

```bash
HEX_PERSONAL_APP_NAME="Hex Personal" HEX_PERSONAL_BUNDLE_ID="com.vimcity.Hex.personal" ./dev/install-personal.sh
```

## Update From Upstream

Check upstream status:

```bash
./dev/check-upstream.sh
```

Then merge upstream, keep local `README.md`, and reinstall:

```bash
./dev/update-from-upstream.sh
```

## Notes

- Plain `Esc` stays free.
- `Ctrl+Esc` cancels recording.
- App auto-update is disabled in personal installs. Updates come through `git` + rebuild.

## License

MIT. See `LICENSE`.
