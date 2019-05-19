. ./conf

: ${DESTDIR:=NONE}
: ${PREFIX:=/usr}
: ${MANDIR:=$DESTDIR$PREFIX/share/man}
: ${BINDIR:=$DESTDIR$PREFIX/bin}

if [ "$DESTDIR" = "NONE" ]; then
	echo "$0: fatal: set DESTDIR before trying to install." >&2
	exit 99
fi

redo-ifchange build

for page in $MAN_1_PAGES
do
    install -Dm0644 "$page" "$MANDIR"/man1/"${page%*.man}"
done

for page in $MAN_5_PAGES
do
    install -Dm0644 "$page" "$MANDIR"/man5/"${page%*.man}"
done

for binary in $BINARIES
do
    install -Dm0755 "$binary" "$BINDIR/$binary"
done
