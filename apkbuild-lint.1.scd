apkbuild-lint(1)

# NAME

apkbuild-lint - A linter for Alpine Linux's build files (apkbuild)

# SYNOPSIS

*apkbuild-lint* <apkbuild...>

# DESCRIPTION

apkbuild-lint is a linter for packages in aports. It will check the *APKBUILD*
file for violations of policy, superfluous statements, stylistic violations
and others. See *alint(5)* under the apkbuild-lint section for an explanation
of each violation that apkbuild-lint checks for.

apkbuild-lint will print the policy violations found and exit 1, if no violations
are found then nothing will be printed and it will exit 0.

# OUTPUT

apkbuild-lint will print to stdout whenever a policy violation is found in the
following format

	SEVERITYCERTAINITY:[TAG]:PATH::MSG

- *SEVERITY* refers to how severe a violation is, ranging from *S* to *M*.
- *CERTAINITY* refers to how likely it is not a false positive, ranging from *C* to *P*
- *TAG* refers to the tag of the violation, see *alint(5)* for more details.
- *PATH* refers to the path given for *apkbuild-lint* to check.
- *LINE* refers to the number of the line where the violation was found.
- *MSG* is a short message meant for humans to know what is the violation.

# AUTHORS

Maintained by Leo <thinkabit.ukim@gmail.com>

# SEE ALSO

*alint(5)* *aports-lint(1)*
