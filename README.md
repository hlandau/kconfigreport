# kconfigreport

Generates XHTML reports of how the Linux kernel is configured by different
Linux distributions.

[**See the published reports.**](https://hlandau.github.io/kconfigreport)

## Building

Clone and run `make`. You will need GNU make, Python 3, `7z` and `wget`
installed.

The report is produced in the directory `report`. An SQLite3 database,
`configs.db`, is also produced, which can be used to interrogate the data. The
configurations used to generate the data are placed in `configs`.

## Adding support for distros

Add a file named `scripts/mk/DISTRO.mk` and add an include for it in the
Makefile. Pull requests accepted.

Currently the kernel versions used for each distro are hardcoded. In the future
this should be fixed to something more sophisticated.

## Licence

  © 2017 Hugo Landau <hlandau@devever.net>      MIT License

