#!/bin/sh

title() {
  echo "
  ___  ____ _          _     _                  
  |  \/  (_) |        | |   (_)                 
  | .  . |_| | ___   _| |    _ _ __  _   ___  __
  | |\/| | | |/ / | | | |   | | '_ \| | | \ \/ /
  | |  | | |   <| |_| | |___| | | | | |_| |>  < 
  \_|  |_/_|_|\_\\__,_\_____/_|_| |_|\__,_/_/\_\

  "
}

. orion/log

[ ! $EUID -ne 0 ] && \
    error "please don't run as root"

deps=(gcc wget unzip tar patch sed git cpio xz grep awk xorriso)

for dep in ${deps[@]}; do
    if [[ ! -e /bin/$dep ]]; then
        info "dependency $1 not found"
        fail=yes
    fi
done

[[ $fail = yes ]] && exit 1

title && sleep 0.7

if [[ ! -d rootfs ]]; then

mkdir rootfs
cd rootfs

touch pkgs

mkdir -p dev etc home mnt proc opt root share srv sys tmp var
mkdir -p usr/bin usr/etc usr/lib
mkdir -p src/build src/dl

ln -s usr/bin bin
ln -s usr/bin sbin

ln -s usr/lib lib
ln -s usr/lib lib64

cd usr

ln -s bin sbin
ln -s lib lib64

cd ..

chmod 1777 tmp
chmod 700 root

cd ..

cp -rf files/bin/* rootfs/bin
cp -rf files/etc/* rootfs/etc
cp -rf files/root/* rootfs/root

fi

rm -rf rootfs/pkg
cp -rf pkg rootfs/pkg
cp -rf orion rootfs
cp config rootfs/src

cd rootfs/orion

./main -i base

cd ../..

if [[ ! -e rootfs/usr/bin/orion ]]; then
  ln -s ../../orion/main rootfs/usr/bin/orion
fi