#!/usr/bin/zsh

##
## This file is for updating the nano-syntax-highlighting repository, and then
## copying the files over locally and making necessary modifications for them to
## work in ddayenv. This includes changing the include statements, and also
## changing color 'black' and all it's variants to 'blue', because 'black'
## renders as invisible for some reason.
##
## This script should never be sourced (as in source <> or . <>), but instead
## just called with the absolute path (e.g. simply ./update.zsh).
##

local sourcedir="${0:A:h}"                                       # "$(realpath "$(dirname "$0")")"
local repodir="${sourcedir%%/bspwm*}/bspwm"                      # "$(realpath ${sourcedir}/../..)"
local tmpdir="${repodir}/.tmp"                                   # Use system /tmp directory since it's available, heh
local tgtrepo="${repodir}/.thirdparty/nano-syntax-highlighting"  # "$(realpath ${sourcedir}/../../.thirdparty/nano-syntax-highlighting)"
local syntaxdir="${repodir}/home/.config/nano/syntax"            # "$(realpath ${sourcedir}/../../config/nano/syntax)"
local syntaxtmpdir="${tmpdir}/nano-syntax-tmp"                   # "${syntaxdir}/.tmp"
local nanorc="${sourcedir}/nanorc"

for f in sourcedir repodir tmpdir tgtrepo syntaxdir syntaxtmpdir nanorc; do
	#read comp1 < <(print -P %F{#73c25d}%B$f%b%f)
	#read comp2 < <(print -P %F{#9ce635}$(eval echo \${$f})%f)
	#for comp1 comp2 in "%F{#73c25d}%B$f%b%f" "%F{#9ce635}$(eval echo \${$f})%f"; do print -P "${comp1}:\t\t\t${comp2}"; done
	#for comp1 comp2 in "%F{#73c25d}%B$f%b%f" "%F{#9ce635}$(eval echo \${$f})%f"; do print -P "${comp1}:\t\t\t${comp2}"; done
	printf '\e[32;1m%14s: \e[33m%s\e[0m\n' "$f" "$(eval echo \${$f})"
done

printf '\e[31mAre these correct? [Y/n]: '
read -k1 yn && echo -
if [[ ! $yn =~ ^[Yy]$ ]]; then
	printf '\e[31;1mExiting due to invalid paths.\e[0m\n'
	return 2
fi

printf '\e[32;1mCreating temporary file directory for modified syntax files.. '
[[ ! -d $syntaxtmpdir ]] && mkdir -pv $syntaxtmpdir
printf 'Done.\e[0m\n'

printf '\e[32;1mCreating nano syntax directory structure.. '
[[ ! -d $syntaxdir ]] && mkdir -pv $syntaxdir

# Pull possible updates to the project.
if [[ ! -d "${tgtrepo}" || ! -r "${tgtrepo}" ]]; then
  printf $'Directory %s doesn\'t exist, or is not readable.\n' "${tgtrepo}" >&2
  return 1
fi

# For ´cp´, using '--archive'|'-a', which is the same as '-dR --preserve=all'.
#   -d: Same as --no-dereference --preserve=links (very important).
#   -R: Recursive (ineffective when copying single files like this script).
#   --preserve=all  Preserve mode|ownership|timestamps & context|links|xattr if possible.
# If this becomes a problem, switch to -P (--no-dereference; most important).

# Avoid errors where syntaxtmpdir points to /tmp (almost broke my cpu)
if [[ $(realpath $syntaxtmpdir) = "/tmp" || $syntaxtmpdir =~ ^[/.]*/tmp(/.*)?$ ]]; then
	echo "Fatal error: \$syntaxtmpdir points to /tmp. Thanks to this check, /tmp wasn't wiped." >2
	echo "This has happened before, and that broke polkit and almost required full re-install."
	echo "Fix by getting the .nanorc files from nano-syntax-highlighting to .src2c/.local/nano-syntax/"
	echo "Or really by just having that directory. Will make checks for such later."
	exit 8
fi

# Create nsh directory and the temporary directory between updates.
if [[ ! -d "${syntaxtmpdir}" ]]; then
  printf 'Creating syntax temp directory: %s\n' "${syntaxtmpdir}"
  mkdir -p "${syntaxtmpdir}"
elif (( $(ls -A1 "${syntaxtmpdir}" | wc -l) > 0 )); then
  printf 'Deleting old .nanorc files from temp directory: %s\n' "${syntaxtmpdir}"
  rm -f "${syntaxtmpdir}"/*.nanorc
fi

printf 'Copying all *.nanorc files to %s\n' "${syntaxtmpdir}"
/usr/bin/cp -P -f "${tgtrepo}"/*.nanorc "${syntaxtmpdir}"

printf 'Changing black->blue in %s/*.nanorc\n' "${syntaxtmpdir}"
printf 'Also moving updated (newer) files to main syntax directory.\n\n'
local curfile= targetfile= diffoutput=
for curfile in "${syntaxtmpdir}"/*.nanorc(^@); do
  targetfile="${syntaxdir}/${curfile##*/}"
  sed -E -i 's|color ([[:alnum:]]+,)*(bright)?black(.*)|color \1\2blue\3 \#RTMP|g' "${curfile}"
  if [[ -f "${targetfile}" ]]; then
    ## TODO: The regex doesn't need to be same for both; RTMP needed only for latter. Needs testing.
    diffoutput="$(diff \
       <(grep -E -v '(^i?color ([[:alnum:]]+,)*(bright)?black| [\]#RTMP$)' "${targetfile}") \
       <(grep -E -v '(^i?color ([[:alnum:]]+,)*(bright)?black| [\]#RTMP$)' "${curfile}") \
    )"
    # No changes; Continue
    (( $? == 0 )) && continue
    printf '%1$s%2$s%1$s:\n%3$s\n' ' ---------- ' "${curfile##*/}" "${diffoutput}"
  fi
  # Copy file to target.
  /usr/bin/cp -P -f "${curfile}" "${targetfile}"
done
printf '%1$s(EOF)%1$s\n\n' ' --------------- '

# Remove #RTMP temporary markers from finalized files. (^@) to exclude symlinks.
printf 'Removing temp markers from modified lines in %s/*.nanorc\n' "${syntaxdir}"
for curfile in "${syntaxdir}"/*.nanorc; do sed -E -i 's| \#RTMP||g' "${curfile}"; done

# Copy the nanorc file, which has list of includes as "~/.nano/*", and replace
# all the paths with the ddayenv thirdparty directory. Then, add all the
# includes to target .nanorc if they're not already there.
if [[ ! -e "${nanorc}" ]]; then
  printf 'Creating %s\n' "${nanorc}"
  touch "${nanorc}"
fi

printf 'Appending missing includes to %s\n' "${nanorc}"
local count=0
sed "s|~/\.nano|${syntaxdir//./\\.}|g" "${tgtrepo}/nanorc" | while read -r line; do
  ! grep -q "$line" "${nanorc}" && printf '%s\n' "$line" >> "${nanorc}" && ((count++))
done

(( count == 0 )) && count="No"
printf '%s new includes added to %s\n' "${count}" "${nanorc}"

# Remove temporary directory
printf 'Removing syntax temp directory: %s\n' "${syntaxtmpdir}"
rm -rf "${syntaxtmpdir}"

##
## Fix bugs in the NSH repo
##

printf 'Manually fixing bugs in the temporary syntax file copies.\n'

# Usually, whitespace errors are in format color ,red "\t+ +| +\t+". This is not
# the case in git.nanorc, where it says "\t+", coloring all tabs as error. This
# is the only file I found this error in so far, but this pattern will fix that
# anyway, in case the same error is found later in another file.
local taberr_fix_pattern='s:^(color ,red )("\t\+")$:\1"\t\+ \+| \+\t\+":g'

# git.nanorc bug with tabs identified as errors.
sed -E -i ${taberr_fix_pattern} "${syntaxdir}/git.nanorc"

# nanorc.nanorc bug with 'brightnormal' (invalid syntax).
sed -E -i '/icolor brightnormal.*/d' "${syntaxdir}/nanorc.nanorc"

##
## Final sync and exit
##

printf '\nSyncing filesystem.. '
sync
printf 'done!\n'
exit 0
