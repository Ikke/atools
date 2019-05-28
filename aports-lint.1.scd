aports-lint(1)

# NAME

aports-lint - A linter for Alpine Linux's ports (aports)

# SYNOPSIS

*aports-lint* <apkbuild...>

# DESCRIPTION

aports-lint is a linter for packages in aports and their relation to other
packages in the same repo, it searches for instances of policy violations,
duplicate packages and others. See *alint(5)* under the aports-lint section
for an explanation of each violation that aports-lint checks for.

aports-lint will print the policy violations found and exit 1, if no violations
are found then nothing will be printed and it will exit 0.

# OUTPUT

aports-lint will print to stdout whenever a policy violation is found in the
following format

	SEVERITYCERTAINITY:[TAG]:PATH::MSG

- *SEVERITY* refers to how severe a violation is, ranging from *S* to *M*.
- *CERTAINITY* refers to how likely it is not a false positive, ranging from *C* to *P*
- *TAG* refers to the tag of the violation, see *alint(5)* for more details.
- *PATH* refers to the path given for *apkbuild-lint* to check.
- *MSG* is a short message meant for humans to know what is the violation.

# AUTHORS

Maintained by Leo <thinkabit.ukim@gmail.com>

# SEE ALSO

*alint(5)* *apkbuild-lint(1)*
