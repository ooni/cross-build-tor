# Cross tor build

This repo includes tooling for making cross platform builds for tor.

The primary goal is that of generating a suitable orconfig.h for use inside of
go-libtor. The goal is not actually that of building a working tor executable
or library, though it should be possible to do that as well with minimal
changes to the repo.

## Usage

```
make clean
make orconfig.h
```
