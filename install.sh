#! /bin/bash
trap 'echo error in $BASH_COMMAND >&2; exit 1' ERR

FLAVOR=$1
[ $FLAVOR ]

: "${GDB:=/mnt/git/tmp/nvme/gdb}"
: "${OVMF:=/mnt/git/tmp/nvme}"
: "${OVMF2:=/mnt/nv/mwilck/nvme-poc/ovmf}"
: "${EFITOOLS:=/mnt/nv/mwilck/nvme-poc/efitools}"

SD=Build/OvmfX64/DEBUG_GCC5
COMMIT=HEAD
while git show $COMMIT | grep -q a/install.sh; do
    COMMIT="$COMMIT"~
done
COMMIT=$(git describe --tags $COMMIT)
NAME=$COMMIT-$FLAVOR

[ ! -d "$GDB/$NAME" ]
[ ! -f "$OVMF/$NAME-code.bin" ]
[ ! -f "$OVMF2/$NAME-code.bin" ]

cp -r "$SD/X64" "$GDB/$NAME"
cp -v "$SD/FV/OVMF_CODE.fd" "$OVMF/$NAME-code.bin"
cp -v "$SD/FV/OVMF_VARS.fd" "$OVMF/$NAME-vars.bin"
ln -v "$SD/FV/OVMF_CODE.fd" "$OVMF2/$NAME-code.bin"
ln -v "$SD/FV/OVMF_VARS.fd" "$OVMF2/$NAME-vars.bin"
cp -v "$SD/X64/NvmeOfCli.efi" "$EFITOOLS/NvmeOfCli-$NAME.efi"
