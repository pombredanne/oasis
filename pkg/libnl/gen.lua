cflags{
	'-D _GNU_SOURCE',
	[[-D 'SYSCONFDIR="/etc/libnl"']],
	'-I include',
	'-I $dir',
	'-I $outdir/include',
	'-I $srcdir/include',
	'-I $srcdir/include/linux-private',
}

build('sed', '$outdir/include/netlink/version.h', '$srcdir/include/netlink/version.h.in', {
	expr={
		'-e s,@PACKAGE_STRING@,\'libnl 3.3.0\',',
		'-e s,@PACKAGE_VERSION@,3.3.0,',
		'-e s,@MAJ_VERSION@,3,',
		'-e s,@MIN_VERSION@,3,',
		'-e s,@MIC_VERSION@,0,',
		'-e s,@LT_CURRENT@,225,',
		'-e s,@LT_REVISION@,0,',
		'-e s,@LT_AGE@,25,',
	},
})

pkg.hdrs = {
	copy('$outdir/include/netlink', '$srcdir/include/netlink', {
		'addr.h',
		'attr.h',
		'cache.h',
		'cache-api.h',
		'data.h',
		'errno.h',
		'handlers.h',
		'hash.h',
		'hashtable.h',
		'list.h',
		'msg.h',
		'netlink.h',
		'netlink-compat.h',
		'netlink-kernel.h',
		'object.h',
		'object-api.h',
		'socket.h',
		'types.h',
		'utils.h',
		'genl/ctrl.h',
		'genl/family.h',
		'genl/genl.h',
		'genl/mngt.h',
	}),
	'$outdir/include/netlink/version.h',
}

lib('libnl-3.a', [[lib/(
	addr.c attr.c cache.c cache_mngr.c cache_mngt.c data.c
	error.c handlers.c msg.c nl.c object.c socket.c utils.c
	version.c hash.c hashtable.c
)]], {'$dir/headers'})

lib('libnl-genl-3.a', 'lib/genl/(ctrl.c family.c genl.c mngt.c)', {'$dir/headers'})

fetch 'git'