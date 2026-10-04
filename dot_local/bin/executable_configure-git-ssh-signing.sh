#!/bin/sh
set -eu

git config --global gpg.ssh.defaultKeyCommand "ssh-add -L"
git config --global user.email "rahman.fahmiaulia@gmail.com"
git config --global user.name "Fahmi Aulia Rahman"
git config --global gpg.format ssh
git config --global user.signingKey "$HOME/.ssh/id_ed25519.pub"
