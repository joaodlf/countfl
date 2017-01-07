# countfl
Count files and lines in a directory.

## Installation

A direct install is provided for macOS, Linux, and OpenBSD:

```
curl https://raw.githubusercontent.com/joaodlf/countfl/master/install.sh | sh
```

Binaries (including Windows) can also be [downloaded](https://github.com/joaodlf/countfl/releases).

## Example

```
$ countfl php
Finding .php files in .
============
Total Files: 5895
Total Lines: 1168902
Total Errors: 0
``` 

Excluding a directory:

```
$ countfl -e vendor/ php
Finding .php files in .
============
Total Files: 871
Total Lines: 215495
Total Errors: 0
```

Available flags:

```
$ countfl -h
```

## Why?

Wanted to play with Go! goroutines, sync/atomic, etc... There are probabaly much better and faster ways to implement a file counter, and I welcome all pull requests!
