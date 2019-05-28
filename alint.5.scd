alint(5)

# NAME

alint - linting tags

# DESCRIPTION

A tag is an attribute given to each test in alint, each tag has an explanation
of what it does and a brief on how to resolve it. each test can be skipped by 
setting an environment variable formed by SKIP_ + the tag in uppercase with the
dashes replaced by underscore.

# TAGS (aports-lint)

The following tags are used by the *aports-lint* program.

## Duplicate package

The Package being introduced is already present in another repo. Solve the
conflict by:

- If the package in the uppermost repo has more recent changes, merge them.
- Then delete the package in the upper repo.

Duplicate packages will shadow eachother in the repo and the one with the
higher version will win, it can also cause programs to compile against
the wrong version of a package. E.g: if *main/foo-1-r0* and *testing/foo-2-r0* exist
and *main/bar* is updated to version 2 which requires *foo>=2-r0* then it will
fail because it will only find *main/foo-1-r0* and not *testing/foo-2-r0*.

## upper-repo-depends

The package depends on a package in a upper repo. The package must be moved to 
the upper repo or the dependency moved to the repo the package is.

Packages cannot depend on a package on an upper repo. Packages in main cannot
depend on packages in other repos. Packages in community can depend on main
and itself only. Packages in testing can depend on main, community and itself
only. Packages in unmaintained can depend on package on any repo but non-free.

## duplicate-depends

The APKBUILD has duplicate depends. One of them must be removed.

Declaring duplicate dependencies is superfluous.

## upper-repo-makedepends

The package makedepends on a package in a upper repo. The package must be moved
to the upper repo or the dependency moved to the repo the package is.

Packages cannot makedepend on a package on an upper repo. Packages in main cannot
makedepend on packages in other repos. Packages in community can depend on main
and itself only. Packages in testing can makedepend on main, community and itself
only. Packages in unmaintained can makedepend on packages of any repo but non-free.

## duplicate-makedepends

The APKBUILD has duplicate makedepends. One of them must be removed.

Declaring duplicate dependencies is superfluous.

## upper-repo-checkdepends

The package checkdepends on a package in a upper repo. The package must be moved
to the upper repo or the dependency moved to the repo the package is.

Packages cannot checkdepend on a package on an upper repo. Packages in main cannot
checkdepend on packages in other repos. Packages in community can checkdepend on main
and itself only. Packages in testing can checkdepend on main, community and itself
only. Packages in unmaintained can checkdepend on package on any repo but non-free.

## duplicate-checkdepends

The APKBUILD has duplicate checkdepends. One of them must be removed.

Declaring duplicate dependencies is superfluous.

## pkgname-dirname-mismatch

The pkgname variable of the APKBUILD has value *foo* but the directory in which the
APKBUILD is found is not named *foo*

## depends-makedepends-checkdepends-overlap

A package is present in 2 to 3 of the 3 types of following dependencies: depends,
makedepends and checkdepends. All of them are installed during creation of the package,
please specify only once in the lowest common denominator location.

# TAGS (apkbuild-lint)

The following tags are used by the *apkbuild-lint* program

## default-builddir-value

The value of builddir matches the default which is *$srcdir/$pkgname-$pkgver*.
The *builddir* declaration can be removed.

Starting with v2.29.0 of *abuild* the value is set automatically.

## unnecessary-return-1

The APKBUILD has *|| return 1* statements. They can be safely removed.

Starting with version v2.15.0 of *abuild* the building process is executed
with *set -e* effectively adding a *|| return 1* to every command.

## pkgname-quoted

The APKBUILD's *pkgname* variable is quoted. It must not be quoted.

## pkgver-quoted

The APKBUILD's *pkgname* variable is quoted. It must not be quoted.

## empty-variable

The APKBUILD has variables that are empty values, they can safely be removed.

Empty variables can be removed to make the APKBUILD smaller and more
concise.

## custom-variable

The APKBUILD has custom variables that are not prefixed with an underscore.
prefix the variables with underscore.

Variables that do no affect behaviour of *abuild* should be prefixed with an
underscore so maintainers and contributors can easily distinguish their
importance.

## indent-tabs

The APKBUILD is using spaces instead of tabs for indenting. Replace the
spaces with tabs.

APKBUILDs use tab characters (\t) not spaces for indentation.

## trailing-whitespace

The APKBUILD has trailing whitespace characters. Remove them.

Trailing whitespace is superfluous.

## function-keyword

The APKBUILD uses the function keyword to declare a function. Use
*function()* instead.

the function keyword is a bashism. *abuild* uses Posix-compliant
shell with the *local* keyword.

## space-before-function-parenthesis

The APKBUILD has a space character between the name of a function
and the paranthesis that denote it is a function. Remove the superfluous
space.

## space after-function-parenthesis

The APKBUILD doesn't have a space after the function parenthesis or has more
than one space. Use only one space after the function parenthesis.

## newline-opening-brace

The APKBUILD has a newline before the opening brace of a function. Put the
opening brace in the same line as the declaration with one space after the
function parenthesis.

## superfluous-cd-builddir

The APKBUILD has *cd "$builddir"* statements that are superfluous. Remove them.

Staring with v3.3.0 of *abuild* the *prepare*, *build*, *check* and *package*
functions automatically have their working directory set to the value of
*builddir*. It is also possible that there are 2 *cd "$builddir"* statements
one after the other.

## pkgname-has-uppercase

pkgname has uppercase characters, pkgname must have only lowercase characters.

## pkgver-has-pkgrel

pkgver has *-r* followed by a number, that is reserved for the relaease of a package
as defined by the *pkgrel* variable.
