A script I created to take the hassle out of using Firefox for web development and personal browsing.

# Using #

1. Make a new Firefox profile by running `/Path/To/Firefox.app/Contents/MacOS/firefox -p`. The name can't contain spaces for this script to work. Make more by quitting Firefox and doing that again.
2. Run that command again and choose your primary profile. Make sure "don't show this again" is checked.
3. Copy .icns files named Firefox-{ProfileName}.icns into this folder before running.
4. Run with `make-ff-profile.sh ProfileName1 ProfileName2 ...`
5. You should have Firefox-{ProfileName}.app bundles in /Applications that will launch their respective profiles automatically.

# Features #

* Changes the process name in:
  * The Finder
  * Cmd-Tab
  * The menubar
  * Activity Monitor
  * `top`, `ps`, and other UNIX commands
* Create as many profiles as you like; run the default one the normal way, without the profile switcher

# Notes #

* Please don't create a Firefox profile called Bin or bin. You'll clobber the firefox-bin executable and your copy may not work.
* You can change the place where the copies get created by editing the PREFIX= line in `make-ff-profile.sh`
* If you have Firefox in a weird location, edit that in on the FF= line.

# link-except.rb #

You can also use `link-except.rb` on its own. It "deep-symlinks" from one folder to another, creating subfolders and symlinking only files, so it can then _not_ symlink any files you want it to exclude. Any folder with no excluded files gets symlinked in its entirety. (i.e. `link-except.rb` with no exclude\_files is a trivial alias for `ln -s`.) Usage is:

    link-except.rb from_folder to_folder exclude_file [...]

exclude\_file paths can be relative to from\_folder or absolute.