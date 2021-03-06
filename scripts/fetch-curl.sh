: "${SHA256SUM:=sha256sum}"
: "${PAXREAD:=pax -r}"

set -e

if [ "$#" != 1 ] ; then
	echo 'usage: fetch-curl.sh dir' >&2
	exit 2
fi

dir=$1
shift

cd "$dir"

if [ -e src ] ; then
	rm -rf src
fi

if ! $SHA256SUM -c sha256 2>/dev/null ; then
	curl -L -K url -O
	$SHA256SUM -c sha256
fi

while read -r _ archive ; do
	case $archive in
	*.tar.gz|*.tgz)
		tool=gzip ;;
	*.tar.bz2)
		tool=bzip2 ;;
	*.tar.xz)
		tool=xz ;;
	*)
		tool=
	esac
	if [ -n "$tool" ] ; then
		"$tool" -d -c "$archive" | $PAXREAD -s ',^[^/]*,src,' '*/*'
	fi
done <sha256

if [ -d patch ] ; then
	git apply -v --whitespace=nowarn --directory "$dir/src" patch/*
fi
