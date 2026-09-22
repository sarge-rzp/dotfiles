# Mount the encrypted "Nix Store" APFS volume at /nix, at boot.
#
# Installed by configuration.nix as the body of the org.nixos.darwin-store
# LaunchDaemon. Its text is inlined into the plist at build time rather than
# referenced from /nix/store, because this script is what MAKES /nix exist: a
# store path here would deadlock at boot.
#
# Background: the Nix installer puts the store on its own encrypted APFS
# volume. Three things have to line up for it to appear at /nix:
#   1. /etc/synthetic.conf  - synthesises the /nix mountpoint at boot
#   2. the System keychain  - holds the volume passphrase (account "Nix Store")
#   3. this daemon          - unlocks the volume and mounts it ON /nix
#
# /etc/fstab does NOT do step 3 on macOS 26: the system claims every APFS
# volume in the boot container and mounts it at /Volumes/<name> before fstab
# is honoured, so the store has to be taken back explicitly. Losing this
# daemon leaves every /nix symlink dangling - including /etc/static/zshrc,
# which silently reduces the login shell to a bare PATH.
set -u
export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
exec >>/var/log/darwin-store.log 2>&1
echo "=== $(date '+%F %T') darwin-store run (pid $$) ==="

# The mountpoint itself comes from /etc/synthetic.conf; synthesise it if the
# boot-time pass has not happened yet.
[ -d /nix ] || /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t

# Boot timing decides which branch below is needed, so both must exist: if this
# daemon wins the race the volume is merely locked, if the system wins it is
# already mounted on /Volumes and has to be released first.
for attempt in 1 2 3 4 5; do
  if [ -d /nix/store ]; then
    echo "mounted at /nix (attempt $attempt)"
    # Keep Spotlight out of the store. Left to itself it crawls every store
    # path and pins the machine at a load average in the dozens.
    mdutil -i off /nix >/dev/null 2>&1
    echo "=== ok ==="
    exit 0
  fi

  if [ -d "/Volumes/Nix Store" ]; then
    echo "attempt $attempt: unmounting /Volumes/Nix Store"
    diskutil unmount force "/Volumes/Nix Store"
  fi

  echo "attempt $attempt: mounting at /nix"
  if ! diskutil mount -mountPoint /nix "Nix Store"; then
    echo "attempt $attempt: plain mount failed, unlocking from System keychain"
    security find-generic-password -a "Nix Store" -w /Library/Keychains/System.keychain \
      | diskutil apfs unlockVolume "Nix Store" -mountpoint /nix -stdinpassphrase
  fi
  sleep 2
done

echo "FAILED to mount /nix after 5 attempts"
echo "=== fail ==="
exit 1
