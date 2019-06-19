apkbuild-fixer(1)

# NAME

apkbuild-fixer - Fix violations found by apkbuild-lint

# SYNOPSIS

*apkbuild-fixer* <apkbuild...>

# DESCRIPTION

apkbuild-fixer fixes linting violations found by *apkbuild-lint(1)* by modifying
the APKBUILD in-place. It calls *apkbuild-lint* after each fix to a particular
violation done. 

Note that not all violations have automatic fixes and while care is
taken to avoid breaking the APKBUILD it might happen in some edge cases.

# FIXES

The following violations can be fixed automatically, but manual review is recommended:

- AL10 (space-before-function-parenthesis)
	- Fixed by rewriting the function name to match the norm.
- AL11 (space-after-function-parenthesis)
	- Fixed by rewriting the function name to match the norm.

- AL2 (unnecessary-return-1)
	- Removes the *|| return 1* from the line
	- Removes the line if only the *|| return 1* is present
		- Checks previous line for *\\* and removes it.

- AL5 (empty-variable)
	- Remove the empty variable

- AL13 (superfluous-cd-builddir)
	- Remove the *cd "$builddir"* and any following empty lines

- AL1 (default-builddir-value)
	- Remove the *builddir* variable

apkbuild-fixer will also rename *\_builddir* to *builddir* as it is very common from
before the *builddir* variable was a thing.

# AUTHORS

Maintained by Leo <thinkabit.ukim@gmail.com>

# SEE ALSO

*alint(5)* *apkbuild-lint(1)*
