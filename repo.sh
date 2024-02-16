#!/bin/bash
script_full_path=$(dirname "$0")
cd $script_full_path || exit 1

rm Packages Packages.bz2 Packages.xz Packages.zst Release
# rm Release.gpg
echo "[Repository] Generating Packages..."
apt-ftparchive packages ./pool > Packages
zstd -q -c19 Packages > Packages.zst
xz -c9 Packages > Packages.xz
bzip2 -c9 Packages > Packages.bz2

echo "[Repository] Generating Release..."
apt-ftparchive \
		-o APT::FTPArchive::Release::Origin="frcoal" \
		-o APT::FTPArchive::Release::Label="frcoal" \
		-o APT::FTPArchive::Release::Suite="stable" \
		-o APT::FTPArchive::Release::Version="1.0" \
		-o APT::FTPArchive::Release::Codename="ios" \
		-o APT::FTPArchive::Release::Architectures="iphoneos-arm iphoneos-arm64 watchos-arm watchos-arm64" \
		-o APT::FTPArchive::Release::Components="main" \
		-o APT::FTPArchive::Release::Description="frcoal" \
		release . > Release

if [ $# -lt 1 ]; then
	echo "[Repository] Pushing Files..."
	rm CNAME
	echo frcoal.cfd > CNAME
	git add .
	git commit -m "frcoal"
	git push --force
	rm CNAME
	echo frcoal623vobrv5c5rqp4ct4qlispcvkyd3pxgluvuvqvgzl5vrnk2id.onion > CNAME
else
	echo "[Repository] NOT pushing files!! LOL"
fi

echo "[Repository] Finished"
