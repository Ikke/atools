#!/usr/bin/env bats

cmd=./apkbuild-lint
apkbuild=$BATS_TMPDIR/APKBUILD

assert_match() {
	output=$1
	expected=$2

	echo "$output" | grep -qE "$expected"
}

is_travis() {
	test -n "$TRAVIS"
}

@test 'default builddir can be removed' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1
	builddir=/$pkgname-$pkgver

	build() {
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

@test 'cd \"\$builddir\" after cd should be ignored' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1

	build() {
		cd "$builddir/bar"
		foo
		cd "$builddir"
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 0 ]]
}

@test 'cd \"\$builddir\" with brackets should be detected' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1

	build() {
		cd "${builddir}"
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "builddir.*can be removed"
}

@test 'cd \"\$builddir\" with brackets and no quotes should be detected' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1

	build() {
		cd ${builddir}
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "builddir.*can be removed"
}

@test 'cd \"\$builddir\" without quotes should be detected' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1

	build() {
		cd $builddir
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "builddir.*can be removed"
}

@test 'cd \"\$builddir\" should be highlighted if it is also the first' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1

	build() {
		cd $builddir
		cd ${builddir}
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "builddir.*can be removed"
	assert_match "${lines[1]}" "builddir.*can be removed"
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

@test 'custom global variables should start with an underscore' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1
	foo=example
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "prefix.*_"
}

@test 'indentation should be with tabs' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1

	build() {
        foo
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "indent.*tabs"
}

@test 'trailing whitespace should be removed' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1

	build() {
		foo 
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "trailing whitespace"
}

@test 'prefer \$() to backticks' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1

	build() {
		local a=`echo test`
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "instead of backticks"
}

@test 'backticks in comments should be ignored' {
	skip 'false positive'
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1

	build() {
		# `foo` needs to be executed before bar
		foo
		bar
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 0 ]]
}

@test 'function keyword should not be used' {
	is_travis && skip "Broken on CI"
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1

	function build() {
		foo
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "function keyword"
}

@test 'no space between function name and parenthesis' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1

	build () {
		foo
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "before function parenthesis"
}

@test 'one space after function parenthesis' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1

	build()  {
		foo
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "after function parenthesis"
}

@test 'opening brace for function should be on the same line' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1

	build()
	{
		foo
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "newline before function"
}

@test 'cd to builddir dir without cd to other dir can be removed' {
	cat <<-"EOF" >$apkbuild
	pkgname=a
	pkgver=1

	build() {
		cd "$builddir"
		foo
	}
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "builddir.*can be removed"
}

@test 'pkgname must not have uppercase characters' {
	cat <<-"EOF" >$apkbuild
	pkgname=foo
	EOF

	run $cmd $apkbuild
	[[ $status -eq 0 ]]

	cat <<-"EOF" >$apkbuild
	pkgname=Foo
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "pkgname must not have uppercase characters"

	cat <<-"EOF" >$apkbuild
	pkgname=foo-FONT
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "pkgname must not have uppercase characters"

	cat <<-"EOF" >$apkbuild
	pkgname=f_oO
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "pkgname must not have uppercase characters"
	cat <<-"EOF" >$apkbuild
	pkgname=f.o.O
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "pkgname must not have uppercase characters"

	cat <<-"EOF" >$apkbuild
	pkgname=9Foo
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "pkgname must not have uppercase characters"

	cat <<-"EOF" >$apkbuild
	pkgname=FoO
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "pkgname must not have uppercase characters"
}

@test 'pkgver must not have -rN' {
	cat <<-"EOF" >$apkbuild
	pkgname=foo
	pkgver=1
	EOF

	run $cmd $apkbuild
	[[ $status -eq 0 ]]
	
	cat <<-"EOF" >$apkbuild
	pkgname=foo
	pkgver=1-r3
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "pkgver must not have -r or _r"

	cat <<-"EOF" >$apkbuild
	pkgname=foo
	pkgver=0.1_r3a1
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "pkgver must not have -r or _r"

	cat <<-"EOF" >$apkbuild
	pkgname=foo
	pkgver=02-r3a1
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "pkgver must not have -r or _r"
}

@test 'pkgver can have _rc but not -rc' {
	cat <<-"EOF" >$apkbuild
	pkgname=foo
	pkgver=1_rc1
	EOF

	run $cmd $apkbuild
	[[ $status -eq 0 ]]

	cat <<-"EOF" >$apkbuild
	pkgname=foo
	pkgver=02-rc1
	EOF

	run $cmd $apkbuild
	[[ $status -eq 1 ]]
	assert_match "${lines[0]}" "pkgver must not have -r or _r"
}

# vim: noexpandtab
