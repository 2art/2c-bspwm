## **UPDATE.ZSH**
--------------------------------------------------------------------------------

Call the script by direct call, or sourcing:
- `<path>/update.zsh`
- `source <path>/update.zsh`
- `. <path>/update.zsh`

This script will go to the parent repository thirdparty directory, and into
nano-syntax-highlighting repository. The script will pull any changes to the
repo, and then copy (and overwrite) all `*.nanorc` files to `./syntax/` directory.

Some changes are made: `.nanorc` includes are fixed to point to local syntaxes,
and some `.nanorc` files are fixed with `sed`, because they are erroneous.

The `./syntax/` directory should be ignored via `.gitignore`.

## **NANORC SYNTAX**
--------------------------------------------------------------------------------

To make sure a value is disabled, use `unset <option>`.

Quotes inside string parameters don't have to be escaped with
backslashes.  The last double quote in the string will be treated as
its end.  For example, for the "brackets" option, `""')>]}"` will match
`", ', ), >, ]`, and `}`.


### **Syntax Highlighting File**

syntax "short description" `filename regex" ...`

The `none` syntax is reserved; specifying it on the command line is
the same as not having a syntax at all.  The `default` syntax is
special: it takes no filename regexes, and applies to files that
don't match any other syntax's filename regexes.

color foreground,background `"regex" ["regex"...]`
icolor foreground,background `"regex" ["regex"...]`

"color" will do case sensitive matches, while "icolor" will do case
insensitive matches.

Valid colors: `white`, `black`, `red`, `blue`, `green`, `yellow`, `magenta`, `cyan`.
For foreground colors, you may use the prefix `bright` to get a
stronger highlight.

To use multi-line regexes, use the `start="regex"` `end="regex"`
`[start="regex" end="regex"...]` format.

If your system supports transparency, not specifying a background
color will use a transparent color.  If you don't want this, be sure
to set the background color to black or white.

If you wish, you may put your syntaxes in separate files.  You can
make use of such files (which can only include `syntax`, `color`, and
`icolor` commands) as follows:

`include "/path/to/syntax_file.nanorc"`

Unless otherwise noted, the name of the syntax file (without the
".nanorc" extension) should be the same as the "short description"
name inside that file.  These names are kept fairly short to make
them easier to remember and faster to type using `nano -Y` option.

All regexes should be extended regular expressions.

[Example Syntax Highlighting File](https://fossies.org/linux/nano/syntax/nanorc.nanorc)

\# syntax nanorc "\.?nanorc(\.in)?$"
```
comment "#"
```

\# Everything that does not get recolored is invalid
```
olor brightred ".*"
```

\# Color names
```
color yellow "^[[:blank:]]*(i?color|set[[:blank:]]+((error|function|key|mini|number|prompt|scroller|selected|spotlight|status|stripe|title)color))[[:blank:]]+(bold,)?(italic,)?(((bright|light)?(white|black|red|blue|green|yellow|magenta|cyan))|normal|pink|purple|mauve|lagoon|mint|lime|peach|orange|latte|grey|gray)?(,(((light)?(white|black|red|blue|green|yellow|magenta|cyan))|normal|pink|purple|mauve|lagoon|mint|lime|peach|orange|latte|grey|gray))?\>"
```

\# Keywords
```
color brightgreen "^[[:blank:]]*(set|unset)[[:blank:]]+(afterends|allow_insecure_backup|atblanks|autoindent|backup|boldtext|bookstyle|breaklonglines|casesensitive|constantshow|cutfromcursor|emptyline|historylog|indicator|jumpyscrolling|linenumbers|locking|magic|minibar|mouse|multibuffer|noconvert|nohelp|nonewlines|positionlog|preserve|quickblank|rawsequences|rebinddelete|regexp|saveonexit|showcursor|smarthome|softwrap|stateflags|suspendable|tabstospaces|trimblanks|unix|wordbounds|zap)\>"
color brightgreen "^[[:blank:]]*set[[:blank:]]+(backupdir|brackets|errorcolor|functioncolor|keycolor|matchbrackets|minicolor|numbercolor|operatingdir|promptcolor|punct|quotestr|scrollercolor|selectedcolor|speller|spotlightcolor|statuscolor|stripecolor|titlecolor|whitespace|wordchars)[[:blank:]]+"
color brightgreen "^[[:blank:]]*set[[:blank:]]+(fill[[:blank:]]+-?[[:digit:]]+|(guidestripe|tabsize)[[:blank:]]+[1-9][0-9]*)\>"
color brightgreen "^[[:blank:]]*bind[[:blank:]]+((\^([A-Za-z]|[]/@\^_`-]|Space)|([Ss][Hh]-)?[Mm]-[A-Za-z]|[Mm]-([][!"#$%&'()*+,./0-9:;<=>?@\^_`{|}~-]|Space))|F([1-9]|1[0-9]|2[0-4])|Ins|Del)[[:blank:]]+([a-z]+|".*")[[:blank:]]+(main|help|search|replace(with)?|yesno|gotoline|writeout|insert|browser|whereisfile|gotodir|execute|spell|linter|all)([[:blank:]]+#|[[:blank:]]*$)"
color brightgreen "^[[:blank:]]*unbind[[:blank:]]+((\^([A-Za-z]|[]/@\^_`-]|Space)|([Ss][Hh]-)?[Mm]-[A-Za-z]|[Mm]-([][!"#$%&'()*+,./0-9:;<=>?@\^_`{|}~-]|Space))|F([1-9]|1[0-9]|2[0-4])|Ins|Del)[[:blank:]]+(all|main|search|replace(with)?|yesno|gotoline|writeout|insert|ext(ernal)?cmd|help|spell|linter|browser|whereisfile|gotodir)([[:blank:]]+#|[[:blank:]]*$)"
color brightgreen "^[[:blank:]]*extendsyntax[[:blank:]]+[[:alpha:]]+[[:blank:]]+(i?color|header|magic|comment|formatter|linter|tabgives)[[:blank:]]+.*"
color brightgreen "^[[:blank:]]*(syntax[[:blank:]]+[^[:space:]]+|(formatter|linter)[[:blank:]]+.+)"
color green "^[[:blank:]]*((un)?(bind|set)|include|syntax|header|magic|comment|formatter|linter|tabgives|extendsyntax)\>"
```

\# Strings
```
color brightmagenta "([[:blank:]]|(start|end)=)".+"([[:blank:]]|$)"
```

\# Control codes
```
color bold,pink "[[:cntrl:]]"
```

\# Color commands
```
color magenta "^[[:blank:]]*i?color\>" "\<(start|end)="
```

\# Comments
```
color brightblue "(^|[[:blank:]]+)#.*"
color cyan "^[[:blank:]]*.*"
```

\# Trailing whitespace
```
color ,green "[[:space:]]+$"
```
