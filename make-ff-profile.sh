#!/bin/bash

if [[ $# == 1 ]]; then

# Put icons in the same folder as the script
# This is just to make getting at them easier
cd $(dirname $0)
# Change this line to change output directory
PREFIX=/Applications
FF_copy=$PREFIX/Firefox\($1\).app
# Change this to the location of Firefox.app
FF=/Applications/Firefox.app

# Files we're going to exclude
info_strings=Contents/Resources/en.lproj/InfoPlist.strings
icon=Contents/Resources/firefox.icns
exec_file=Contents/MacOS/firefox

# Remove any previous copies
rm -r $FF_copy

# Create a symlinked copy of Firefox, excluding the files we're going to change
# ($exec_file-dummy means that MacOS will get deep-linked but the executable itself will also be linked)
./link-except.rb $FF $FF_copy $icon $info_strings $exec_file-dummy

# Make FF show up as 'firefox-{profilename} in `top` or the like
# Activity Monitor uses the CFBundleName below
exec_suffix=-$(tr A-Z a-z <<< "$1")
mv $FF_copy/$exec_file{,$exec_suffix}

# Copy in the icon
cp Firefox-$1.icns $FF_copy/$icon

# Edit InfoPlist.strings (change menu-bar name)
# Strings files are meant for international text and are UTF-16, which sed doesn't understand
iconv -f utf-16 -t utf-8 <$FF/$info_strings | sed -Ee "/CFBundleName/s/Firefox/Firefox-$1/" | iconv -f utf-8 -t utf-16 >$FF_copy/$info_strings

# Wrap executable
echo -n '#!/bin/sh
exec $(dirname $0)/firefox'$exec_suffix' -p '$1' -no-remote' > $FF_copy/$exec_file
chmod +x $FF_copy/$exec_file

else for pname in $@; do $0 $pname; done; fi