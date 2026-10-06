# Ambient packages

Public, signed APT repository for Ambient Browser on **Ubuntu 26.04**.
The browser package contains Python source. No personal browser data is included.

## One-time setup

Run in Terminal as your normal desktop user:

```bash
sudo apt install -y curl
curl -fsSL https://raw.githubusercontent.com/Hajime4th/Ambient-Packages/main/setup-browser.sh -o /tmp/setup-ambient-browser.sh
bash /tmp/setup-ambient-browser.sh
```

The script checks Ubuntu's version, installs the signing key, checks its fingerprint,
adds the APT source, installs `ambient-browser`, and points your user launcher at it.
It preserves the old launcher as `ambient-browser.desktop.before-apt` and keeps
browser preferences, bookmarks, cookies, and logins.

Close all Browser windows and reopen Browser after installation.

## Future updates

```bash
sudo apt update
sudo apt install --only-upgrade ambient-browser
```

Normal `sudo apt upgrade` also updates Browser when a newer package is published.
Updates are published here separately from commits to the browser development repo.

## Manual repository configuration

Download `browser/ambient-browser.gpg` to `/etc/apt/keyrings/ambient-browser.gpg`
and check its fingerprint:

`8544 74C6 5414 7D0B 13CD B52B E42E 236F 04EA 0A1F`

Create `/etc/apt/sources.list.d/ambient-browser.sources`:

```text
Types: deb
URIs: https://raw.githubusercontent.com/Hajime4th/Ambient-Packages/main/browser/
Suites: ./
Signed-By: /etc/apt/keyrings/ambient-browser.gpg
```

Then run `sudo apt update`, `sudo apt install ambient-browser`, and run
`ambient-browser-use-system` **without sudo** to switch an existing Ambient launcher.
If a full Ambient OS reinstall restores its bundled launcher, run this last command again.

## Removal

```bash
sudo apt remove ambient-browser
sudo rm /etc/apt/sources.list.d/ambient-browser.sources
sudo rm /etc/apt/keyrings/ambient-browser.gpg
sudo apt update
```

To restore a previously installed Ambient launcher, copy
`~/.local/share/applications/ambient-browser.desktop.before-apt` back to
`~/.local/share/applications/ambient-browser.desktop` if that backup exists.
