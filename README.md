# bson-converter

[![apm](https://img.shields.io/apm/l/bson-converter.svg?style=flat-square)](https://atom.io/packages/bson-converter)
[![apm](https://img.shields.io/apm/v/bson-converter.svg?style=flat-square)](https://atom.io/packages/bson-converter)
[![apm](https://img.shields.io/apm/dm/bson-converter.svg?style=flat-square)](https://atom.io/packages/bson-converter)
[![Travis](https://img.shields.io/travis/idleberg/atom-bson-converter.svg?style=flat-square)](https://travis-ci.org/idleberg/atom-bson-converter)
[![David](https://img.shields.io/david/dev/idleberg/atom-bson-converter.svg?style=flat-square)](https://david-dm.org/idleberg/atom-bson-converter?type=dev)

Converts [BSON](http://bsonspec.org/) into JSON (or CSON) and vice versa

## Installation

### apm

Install `bson-converter` from Atom's [Package Manager](http://flight-manual.atom.io/using-atom/sections/atom-packages/) or the command-line equivalent:

`$ apm install bson-converter`

### Using Git

Change to your Atom packages directory:

```
# Windows
$ cd %USERPROFILE%\.atom\packages

# Linux & macOS
$ cd ~/.atom/packages/
```

Clone the repository as `bson-converter`:

```
$ git clone https://github.com/idleberg/atom-bson-converter bson-converter
```

Install dependencies:

```
cd bson-converter && npm install
```

## Usage

Once installed, two commands are exposed to the [command palette](http://flight-manual.atom.io/getting-started/sections/atom-basics/#_command_palette):

* `BSON: Encode` – encodes JSON and CSON into BSON
* `BSON: Decode` – decodes BSON into JSON or CSON

You can tweak the behavior by adjusting the many options available in the [package settings](http://flight-manual.atom.io/using-atom/sections/atom-packages/#package-settings).

### Keyboard Shortcuts

*The following examples use the macOS keyboard shortcuts. On Linux or Windows use <kbd>Shift</kbd>+<kbd>Super</kbd> as modifier key*

Memorizing the keyboard shortcuts for conversion is easy. Just think of the <kbd>B</kbd> key for BSON, the <kbd>J</kbd> key for JSON:

Action                 | Mnemonic | Shortcut
-----------------------|----------|-----------------------------------------------------------------------------------------
BSON to JSON (or CSON) | “B to J” | <kbd>Ctrl</kbd>+<kbd>Cmd</kbd>+<kbd>B</kbd>, <kbd>Ctrl</kbd>+<kbd>Cmd</kbd>+<kbd>J</kbd>
JSON (or CSON) to BSON | “J to B” | <kbd>Ctrl</kbd>+<kbd>Cmd</kbd>+<kbd>J</kbd>, <kbd>Ctrl</kbd>+<kbd>Cmd</kbd>+<kbd>B</kbd>

## License

This work is licensed under the [The MIT License](LICENSE.md).

## Donate

You are welcome support this project using [Flattr](https://flattr.com/submit/auto?user_id=idleberg&url=https://github.com/idleberg/atom-bson-converter) or Bitcoin `17CXJuPsmhuTzFV2k4RKYwpEHVjskJktRd`
