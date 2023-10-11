# Shell-Var-Reader

Lets say '/usr/local/etc/someconfig.conf' which is basically a shell
config and read via include in a sh or bash script, this can be used
for getting a hash ref conttaining them.

Similarly on systems like FreeBSD, this is also useful for reading
'/etc/rc.conf'.

As it currently stands, it does not understand bash arrays.

```
use Shell::Var::Reader;
use Data::Dumper;

my $found_vars=Shell::Var::Reader->read_in('/usr/local/etc/someconfig.conf');

print Dumper($found_vars);
```



## src_bin/shell_var_reader

This script allows for easy reading of a shells script/config and then
outputing it in a desired format.

```
-r <file>     File to read/run
-o <format>   Output formats
              Default: json
              Formats: json,yaml,toml,dumper(Data::Dumper),shell
-p            Pretty print
-s            Sort
-i <include>  Include file info. May be used multiple times.
-m <munger>   File containing code to use for munging data prior to output.

--tcmdb <dir>       Optionally include data from a Rex TOML CMDB.
--cmdb_host <host>  Hostname to use when querying the CMDB.
                    Default :: undef
--host_vars <vars>  If --cmdb_host is undef, check this comma seperated
                    list JSON Paths in the currently found/included vars
                    for the first possible hit.
                    Default :: HOSTNAME,REX_NAME,REX_HOSTNAME,ANSIBLE_HOSTNAME,ANSIBLE_NAME,NAME
--use_roles [01]    If roles should be used or not with the Rex TOML CMDB.
                    Default :: 1

-h/--help     Help
-v/--version  Version


Include Examples...
-i foo,bar.json       Read in bar.json and include it as the variable foo.
-i foo.toml           Read in foo.toml and merge it with what it is being merged into taking presidence.
-i a.jsom -i b.toml   Read in a.json and merge it, then read in in b.json and merge it.
```

## Install

Perl depends are as below.

- Data::Dumper
- File::Slurp
- Hash::Flatten
- JSON
- JSON::Path
- Rex
- Rex::CMDB::TOML
- String::ShellQuote
- TOML
- YAML::XS

None Perl depends are as below.

- libyaml

### FreeBSD

1. `pkg install p5-Data-Dumper p5-File-Slurp p5-Hash-Flatten p5-JSON
p5-JSON-Path p5-Rex p5-String-ShellQuote p5-TOML p5-YAML-LibYAML p5-App-cpanminus`
2. `cpanm Shell::Var::Reader`

### Debian

1. `apt-get install libfile-slurp-perl libhash-flatten-perl libjson-perl libjson-path-perl
libstring-shellquote-perl libtoml-perl libyaml-libyaml-perl cpanminus`
2. `cpanm Shell::Var::Reader`

### Source

```shell
perl Makefile.PL
make
make test
make install
```
