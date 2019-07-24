alint(5)

# NAME

alint - linting labels and tags

# DESCRIPTION

A label and a tag are 2 attributes given to each test in alint, a label is composed
by a collection of words separated by dashes and it is meant to convey the general
idea of what the test does. A tag is a string with AL followed by an integer, those
being assigned in increasing order as new tests are made but never re-using old ones.

tests can be skipped by setting an environment variable composed of SKIP_ + the label
in uppercase with the dashes replaced by underscore or by setting an environment variable
composed of SKIP_ + the tag.

# Severity

Severity is assigned to each tag and indicates how serious the violation found is:

## Serious (S)

Will cause problems during build or when package is delivered to users. Should be fixed
immediately.

## Important (I)

Might cause problems during build or when the package is delivered to users in certain
situations. Should be fixed soon.

## Minor (M)

Won't directly cause issues during build or when the package is delivered to users.
Should be fixed when convenient

## STYLE (T)

Won't cause any issues, are specific style issues pertinent to a concerned developer
or contributor. the _APKBUILD\_STYLE_ variable can be set to a specific value to enable
a subset of checks that the specific developer or user uses.

When a check belongs to this category this manual page also provides information on which
developers use a specific style check as developers can sometimes both want to have the
same check done on their own style.

Current valid values are:

- leo (style linting for leo)

# Certainty

Certainty is assigned to each tag and indicates how certain a test is that the violation
found is not a false positive

## Certain (C)

The test is certain that this is not a false positive

## Possible (P)

The test is not certain that this is a false positive, but there is a high chance it isn't

# LABELS TAGS (aports-lint)

The following labels and tags are used by the *aports-lint* program.

## duplicate-package [AL22]

The Package being introduced is already present in another repo. Solve the
conflict by:

- If the package in the uppermost repo has more recent changes, merge them.
- Then delete the package in the upper repo.

Duplicate packages will shadow eachother in the repo and the one with the
higher version will win, it can also cause programs to compile against
the wrong version of a package. E.g: if *main/foo-1-r0* and *testing/foo-2-r0* exist
and *main/bar* is updated to version 2 which requires *foo>=2-r0* then it will
fail because it will only find *main/foo-1-r0* and not *testing/foo-2-r0*.

Severity: Serious, Certainty: Certain

## upper-repo-depends [AL16]

The package depends on a package in a upper repo. The package must be moved to 
the upper repo or the dependency moved to the repo the package is.

Packages cannot depend on a package on an upper repo. Packages in main cannot
depend on packages in other repos. Packages in community can depend on main
and itself only. Packages in testing can depend on main, community and itself
only. Packages in unmaintained can depend on package on any repo but non-free.

Severity: Serious, Certainty: Certain

## duplicate-depends [AL17]

The APKBUILD has duplicate depends. One of them must be removed.

Declaring duplicate dependencies is superfluous.

Severity: Minor, Certainty: Certain

## upper-repo-makedepends [AL18]

The package makedepends on a package in a upper repo. The package must be moved
to the upper repo or the dependency moved to the repo the package is.

Packages cannot makedepend on a package on an upper repo. Packages in main cannot
makedepend on packages in other repos. Packages in community can depend on main
and itself only. Packages in testing can makedepend on main, community and itself
only. Packages in unmaintained can makedepend on packages of any repo but non-free.

Severity: Serious, Certainty: Certain

## duplicate-makedepends [AL19]

The APKBUILD has duplicate makedepends. One of them must be removed.

Declaring duplicate dependencies is superfluous.

Severity: Minor, Certainty: Certain

## upper-repo-checkdepends [AL20]

The package checkdepends on a package in a upper repo. The package must be moved
to the upper repo or the dependency moved to the repo the package is.

Packages cannot checkdepend on a package on an upper repo. Packages in main cannot
checkdepend on packages in other repos. Packages in community can checkdepend on main
and itself only. Packages in testing can checkdepend on main, community and itself
only. Packages in unmaintained can checkdepend on package on any repo but non-free.

Severity: Serious, Certainty: Certain

## duplicate-checkdepends [AL21]

The APKBUILD has duplicate checkdepends. One of them must be removed.

Declaring duplicate dependencies is superfluous.

Severity: Minor, Certainty: Certain

## pkgname-dirname-mismatch [AL23]

The pkgname variable of the APKBUILD has value *foo* but the directory in which the
APKBUILD is found is not named *foo*

Severity: Important, Certainty: Certain

## depends-makedepends-checkdepends-overlap [AL24]

A package is present in 2 to 3 of the 3 types of following dependencies: depends,
makedepends and checkdepends. All of them are installed during creation of the package,
please specify only once in the lowest common denominator location.

Severity: Important, Certainty: Certain

# LABELS TAGS (apkbuild-lint)

The following labels and tags are used by the *apkbuild-lint* program

## default-builddir-value [AL1]

The value of builddir matches the default which is *$srcdir/$pkgname-$pkgver*.
The *builddir* declaration can be removed.

Starting with v2.29.0 of *abuild* the value is set automatically.

Severity: Minor, Certainty: Certain

## unnecessary-return-1 [AL2]

The APKBUILD has *|| return 1* statements. They can be safely removed.

Starting with version v2.15.0 of *abuild* the building process is executed
with *set -e* effectively adding a *|| return 1* to every command.

Severity: Minor, Certainity: Certain

## pkgname-quoted [AL3]

The APKBUILD's *pkgname* variable is quoted. It must not be quoted.

Severity: Style, Certainty: Possible

Present in the _APKBUILD\_STYLE_ of:

- leo

## pkgver-quoted [AL4]

The APKBUILD's *pkgver* variable is quoted. It must not be quoted.

Severity: Style, Certainty: Possible

Present in the _APKBUILD\_STYLE_ of:

- leo

## empty-variable [AL5]

The APKBUILD has variables that are empty values, they can safely be removed.

Empty variables can be removed to make the APKBUILD smaller and more
concise.

Severity: Minor, Certainty: Certain

## custom-variable [AL6]

The APKBUILD has custom variables that are not prefixed with an underscore.
prefix the variables with underscore.

Variables that do no affect behaviour of *abuild* should be prefixed with an
underscore so maintainers and contributors can easily distinguish their
importance.

Severity: Important, Certainty: Certain

## indent-tabs [AL7]

The APKBUILD is using spaces instead of tabs for indenting. Replace the
spaces with tabs.

APKBUILDs use tab characters (\t) not spaces for indentation.

Severity: Important, Certainty: Certain

## trailing-whitespace [AL8]

The APKBUILD has trailing whitespace characters. Remove them.

Trailing whitespace is superfluous.

Severity: Important, Certainty: Certain

# backticks-usage [AL25]

The APKBUILD uses backticks for running a shell command, use `$()` instead.

Severity: Serious, Certainty: Possible

## function-keyword [AL9]

The APKBUILD uses the function keyword to declare a function. Use
*function()* instead.

the function keyword is a bashism. *abuild* uses Posix-compliant
shell with the *local* keyword.

Severity: Serious, Certainty: Certain

## space-before-function-parenthesis [AL10]

The APKBUILD has a space character between the name of a function
and the paranthesis that denote it is a function. Remove the superfluous
space.

Severity: Style, Certainty: Certain

Present in the _APKBUILD\_STYLE_ of:

- leo

## space-after-function-parenthesis [AL11]

The APKBUILD doesn't have a space after the function parenthesis or has more
than one space. Use only one space after the function parenthesis.

Severity: Style, Certainty: Certain

Present in the _APKBUILD\_STYLE_ of:

- leo

## newline-opening-brace [AL12]

The APKBUILD has a newline before the opening brace of a function. Put the
opening brace in the same line as the declaration with one space after the
function parenthesis.

Severity: Style, Certainty: Certain

Present in the _APKBUILD\_STYLE_ of:

- leo

## superfluous-cd-builddir [AL13]

The APKBUILD has *cd "$builddir"* statements that are superfluous. Remove them.

Staring with v3.3.0 of *abuild* the *prepare*, *build*, *check* and *package*
functions automatically have their working directory set to the value of
*builddir*. It is also possible that there are 2 *cd "$builddir"* statements
one after the other.

Severity: Minor, Certainty: Possible

## pkgname-has-uppercase [AL14]

pkgname has uppercase characters, pkgname must have only lowercase characters.

Severity: Serious, Certainty: Certain

## pkgver-has-pkgrel [AL15]

pkgver has *-r* followed by a number, that is reserved for the relaease of a package
as defined by the *pkgrel* variable.

Severity: Serious, Certainty: Certain

## _builddir-is-set [AL26]

\_builddir is set instead of builddir, which is an old variable from before builddir
existed as a concept understood by abuild

Severity: Serious, Certainty: Certain
