#!/bin/zsh

set -euo pipefail

repo_root=${0:A:h:h}
derived_data_path=$(mktemp -d "${TMPDIR%/}/hex-personal-build.XXXXXX")
built_app="$derived_data_path/Build/Products/Release/Hex.app"
install_root="$HOME/Applications"
display_name="${HEX_PERSONAL_APP_NAME:-Hex Personal}"
dest_app="$install_root/$display_name.app"
plist="$dest_app/Contents/Info.plist"
bundle_id="${HEX_PERSONAL_BUNDLE_ID:-com.vimcity.Hex.personal}"

cleanup() {
  rm -rf "$derived_data_path"
}

trap cleanup EXIT

cd "$repo_root"

mkdir -p "$install_root"

xcodebuild -scheme Hex -configuration Release -derivedDataPath "$derived_data_path" build

rm -rf "$dest_app"
cp -R "$built_app" "$dest_app"

/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $bundle_id" "$plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleName $display_name" "$plist"

if /usr/libexec/PlistBuddy -c 'Print :CFBundleDisplayName' "$plist" >/dev/null 2>&1; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $display_name" "$plist"
else
  /usr/libexec/PlistBuddy -c "Add :CFBundleDisplayName string $display_name" "$plist"
fi

for key in SUFeedURL SUPublicEDKey SUEnableInstallerLauncherService; do
  /usr/libexec/PlistBuddy -c "Delete :$key" "$plist" >/dev/null 2>&1 || true
done

codesign --force --deep --sign - "$dest_app"

pkill -x "Hex" >/dev/null 2>&1 || true
pkill -x "Hex Debug" >/dev/null 2>&1 || true
open "$dest_app"

printf 'Installed %s\n' "$dest_app"
defaults read "$dest_app/Contents/Info" CFBundleIdentifier
