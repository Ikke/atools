#!/usr/bin/env bats

cmd=apkbuild-lint
apkbuild=$BATS_TMPDIR/APKBUILD

assert_match() {
	output=$1
	expected=$2

	echo "$output" | grep -qE "$expected"
}

@test 'default cd \"\$builddir\" can be removed' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1
	builddir=/$pkgname-$pkgver

	build() {
		cd "$builddir"
		foo
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "builddir"
}

@test 'cd \"\$builddir\" is not highlighted' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	subpackages="py-${pkgname}:_py"

	_py() {
		cd "$builddir" # required
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 0 ]]
}

@test 'cd \"$builddir\" after cd should be ignored' {
	skip "false positive"
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1
	builddir=/$pkgname-$pkgver

	build() {
		cd "$builddir/bar"
		foo
		cd "$builddir"
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 0 ]]
}

@test 'unnecessary || return 1 can be removed' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1

	build() {
		foo || return 1
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "return 1"
}

@test 'plain pkgname should not be quoted' {
	cat <<-"EOF" >$apkbuild
	pkgname="a"
	pkgver=1
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "pkgname.*quoted"
}

@test 'quoted composed pkgname is fine' {
	skip "false positive"
	cat <<-"EOF" >$apkbuild
	pkgname="a"
	_flavor=foo
	pkgname="$pkgname-$_flavor"
	pkgver=1
	EOF

	run $cmd $apkbuild
	[[ $status -eq 0 ]]
}

@test 'pkgver should not be quoted' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver="1"
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "pkgver.*quoted"
}

@test 'empty global variable can be removed' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1
	install=
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "variable.*empty"
}
