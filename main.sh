#!/bin/zsh
# https://yama-mac.com/diskutility_create_macos_install_iso/
set -u -e

if [ $# -ne 1 ]; then
    echo "インストールするバージョンを指定してください"
    exit 1
fi

case $1 in
"12" ) OSNAME="Install macOS Monterey" ;;
"11" ) OSNAME="Install macOS Big Sur" ;;
* ) echo "対応していないバージョンです" ; exit 1;;
esac

echo "下記のmacOSインストールイメージを生成します"
echo $OSNAME

TMPDMG="macos-iso.cdr"
TMPVOL="macos-iso"
TMPISO="macos-iso"

if [ -e /tmp/$TMPDMG.dmg ]; then
    rm /tmp/$TMPDMG.dmg
fi
if [ -e /tmp/$TMPISO.cdr ]; then
    rm /tmp/$TMPISO.cdr
fi

hdiutil create -o /tmp/$TMPDMG -size 15GB -layout SPUD -fs HFS+J
ls /tmp/
ls /Volumes
hdiutil attach /tmp/$TMPDMG.dmg \
    -noverify \
    -mountpoint \
    /Volumes/$TMPVOL
ls /Volumes

sudo "/Applications/$OSNAME.app/Contents/Resources/createinstallmedia" \
    --volume /Volumes/$TMPVOL \
    --nointeraction
ls /Volumes

hdiutil eject -force "/Volumes/$OSNAME"

hdiutil convert /tmp/$TMPDMG.dmg \
    -format UDTO \
    -o /tmp/$TMPISO.cdr

DSTIOS=~"/Desktop/$OSNAME.iso"
mv /tmp/$TMPISO.cdr "$DSTIOS"

rm /tmp/$TMPDMG.dmg
