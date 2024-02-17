# The source code of the boilerplate Python .so-linked file
py_so_file_text="#!/usr/bin/python\n\nfrom ctypes import CDLL\n\nprog = CDLL('"

# A stupid shortcut for case-insensitive grep
alias igrep='grep -i'

# A stupid alias to quickly search through the installed packages list
alias spkg='dpkg -l | grep'

# A stupid alias for ls -l
alias lsl='ls -lArth'

# A stupid alias for ls -a
alias lsa='ls -a'

# Make rsync human-readable
alias rsync='rsync -avhP'

alias :q='exit'

# Make cp command preserve permissions, stupidly
alias cp='cp --preserve=mode,ownership,timestamps'

# Making vim command better
_vim_internal() { [ -z $1 ] && { location=`fzf` && { ! [ -z "$location" ] && vim "$location"; } } || vim $@; }
alias vim='_vim_internal'

# A stupid alias to move to a location and list all of it's contents
# cl() { if ! [ -d "${*:-$PWD}" ]; then echo "This path doesn't exist." 1>&2; return 1; fi; if [ -n "$1" ] && [ "`realpath $*`" != "$PWD" ]; then cd "$*"; fi; lsl; }
cl() { if [ $# -gt 0 ]; then if ! [ -d "$@" ]; then echo "This path doesn't exist." 1>&2; return 1; fi; if [ -n "$1" ] && [ "`realpath $*`" != "$PWD" ]; then cd "$*" && lsl; fi; else lsl; fi; }

# A stupid alias to search through bash history
sbash() { if [ -f $HOME/.bash_history ]; then if [ $# -gt 0 ]; then grep "$@" $HOME/.bash_history; else echo "Please pass one (or more) parameter(s) to search the bash history." 1>&2; return 1; fi; else echo "The bash history file is missing." 1>&2; return 1; fi }

# A stupid function to upgrade all the python packages in the current environment, if one is activated or made available.
# Otherwise, all the packages in the root python installation are upgraded, upon confirmation.
pip-upgrade() {
if [[ $# -ge 1 ]]; then
	directory=`realpath $1`
	if [ -f $directory/bin/activate ]; then
		if [ "$directory" != "$VIRTUAL_ENV" ]; then
			echo -e "$directory recognized\nActivating virtualenv\nUpgrading python packages from $directory env"
			source $directory/bin/activate
		else echo -e "The supplied environment is already active.\nMoving on."
		fi
	else
		echo -e "$1 was not recognized as a valid virtualenv location.\nNo env activated."
		read -p "Do you want to update the home python packages?[y/n] " still_update
		([ "$still_update" = "n" ] || [ "$still_update" = "N" ]) && directory= && still_update= && return 1
	fi;
fi
if [ "$VIRTUAL_ENV" = "" ]; then pip freeze --user; else pip freeze; fi | cut -d"=" -f1 | xargs -n1 pip install -U
	directory= ; still_update=
	[ "$1" != "" ] && [ "$VIRTUAL_ENV" != "" ] && deactivate
	return 0;
}

remove_disabled_snaps() {
	set -eu
	snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do sudo snap remove "$snapname" --revision="$revision"; done
	set +e +u
}

# A stupid alias to make a backup of this and the .vimrc file -- THIS HAS BEEN DECOMISSIONED
# alias backup-aliases='[ -f $HOME/.bash_aliases ] && cp -f $HOME/.bash_aliases $HOME/Housekeeping_Scripts/.bash_aliases.bak; [ -f $HOME/.vimrc ] && cp -f $HOME/.vimrc $HOME/Housekeeping_Scripts/.vimrc.bak'

alias update='sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y'

clean() { sudo apt autoclean -y; sudo apt clean -y; sudo rm -rf ~/.cache/thumbnails/; sudo journalctl --vacuum-time=3d; sudo apt remove --purge -y `spkg "^rc" | awk '{print $2}'`; }

# A stupid alias to batch together some upgrading and clean-up functions
# alias routine='update && sudo snap refresh && remove_disabled_snaps && clean'
alias routine='update && clean'

# A stupid command to reload bash aliases and changes made to the shell so that they
# can be accessed by the current shell. Normally, you'd have to start a new shell.
alias relbash='[ -f $HOME/.bash_aliases ] || ([ -f $HOME/.dotfiles/.bash_aliases ] && ln -sT $HOME/.dotfiles/.bash_aliases $HOME/.bash_aliases); [ -f $HOME/.bashrc ] && source $HOME/.bashrc; [ -f $HOME/.bash_profile ] && source $HOME/.bash_profile;'

# A Bash function to mimic the Python behaviour of mass string duplication by multiplying them.
# If you send 2 (or more) parameters, it prints the '1st param' duplicated '2nd param' number of times.
# If only one param is sent, it echoes it back. If no parameters are sent, you get a surprise.
dupstr() { for i in `seq 1 ${2:-1}`; do printf "${1:-$RANDOM}"; done; [[ "$1" != *"\n" ]] && printf "\n"; }

# A stupid command to find out the minimum value
min() { result=$1; for i in ${@:2}; do [[ $result -gt $i ]] && result=$i; done; echo $result; result=; }
export -f min

# A stupid command to find out the maximum number
max() { result=$1; for i in ${@:2}; do [[ $result -lt $i ]] && result=$i; done; echo $result; result=; }
export -f max

# A stupid script to print prime numbers from the 1st param to the 2nd param
# prime() { for i in `seq $(max $1 2) $2`; do is_prime=true; for j in `seq 2 $(($(echo "scale=0; sqrt($i)" | bc)+1))`; do [ $((i % j)) -eq 0 ] && is_prime=false && break; done; $is_prime && echo $i; done; is_prime=; }
# alias prime='$HOME/Housekeeping_Scripts/prime.py'

# A stupid script to run python django server
runpyserver() {
	if [[ $# -ge 1 ]]; then
		directory=`realpath $1`
		if [ "$VIRTUAL_ENV" != $directory ]; then
			if [[ -f "$directory/bin/activate" ]]; then source "$directory/bin/activate"
			else echo "ENV path provided seems to be wrong"; directory= ; return 1
			fi
		fi
		python `find $directory -maxdepth 2 -mindepth 2 -name "manage.py"` runserver
		directory= ; return 0
	else echo "No ENV path provided."; return 1
	fi
}

# Make Shared Object(.so - equivalent to DLL files in Windows) file from source code files
mkso() { if [[ $# -lt 1 ]]; then (echo "ERROR: No file passed to convert." && return 1); else for name in $@; do (filename=${name##*/} && filename=${filename%.*} && cc -fPIC --shared -o $filename.so $name && filename="" && return 0); done; fi; }

# Make Shared Object(.so - equivalent to DLL files in Windows) file from source code files; creates a python file and links it with the .so file
mkpyso() { if [[ $# -lt 1 ]]; then (echo "ERROR: No file passed to convert." && return 1); else for name in $@; do (filename=${name##*/} && filename=${filename%.*} && cc -fPIC --shared -o $filename.so $name && echo -e $py_so_file_text`realpath $filename`.so"')" >> $filename.py && filename="" && return 0); done; fi; }

#
gc() { if [[ $# -lt 1 ]]; then (echo "ERROR: No file passed to compile and run." && return 1); else (filename=${1##*/} && filename=${filename%.*} && gcc $1 -o $filename -lm && ./$filename ${@:2} && rm $filename && filename="" && return 0); fi; }

#
gcgl() { if [[ $# -lt 1 ]]; then (echo "ERROR: No file passed to compile and run." && return 1); else (filename=${1##*/} && filename=${filename%.*} && gcc -pthread -o $filename $1 -lglfw -lGL -lXrandr -lXxf86vm -lXi -lXinerama -lX11 -lrt -ldl && ./$filename ${@:2} && rm $filename && filename="" && return 0); fi; }

#
gcrc() { if [[ $# -lt 1 ]]; then (echo "ERROR: No file passed to compile and run." && return 1); else echo -e "#include <stdio.h>\n\nint main() {\n\t$1\n}" > ~/Housekeeping_Scripts/gcrc_bash_c.c && gcc -o ~/Housekeeping_Scripts/gcrc_bash_c ~/Housekeeping_Scripts/gcrc_bash_c.c && ~/Housekeeping_Scripts/gcrc_bash_c; fi; }

# A stupid script to compile and run a simple Java program
# Not complete
javarun() { if [[ $# -lt 1 ]]; then (echo "ERROR: No file passed to compile and run." && return 1); else (filename=${1%.*} && echo "$filename" && javac "$1" && java "$filename" ${@:2} && rm "$filename".class && filename="" && return 0); fi; }

# A stupid script to open the file(s) in vim at their last line
viml() { [ $# -gt 0 ] && (for filename in $@; do ([ -f "$filename" ] && vim $filename +`wc -l $filename | awk '{print $1}'` || vim $filename); done;) || vim; }

# A stupid script to kill a process
killp() {
	if [ $# -ge 1 ]; then
		ps aux | egrep "$1|PID"
		read -p "Type the PID of the process to be killed (N to abort) :" pid
		if [[ $pid =~ ^[0-9]+$ ]]; then kill $pid && echo "Process $pid successfully killed.";
		elif [[ $pid = [Nn]* ]]; then echo "This process was aborted." >&2;
		else echo "Please give an appropriate response. Either a PID (to kill) or N (to abort)." >&2; fi
		pid=;
	else echo Pass a search term to look for running processes; fi
}

# A stupid function to latch additional features to installing a package
_install() { sudo apt install $@; for pkg_name in $@; do dpkg -l | awk '{print $2}' | grep $pkg_name > /dev/null && (grep $pkg_name $HOME/.dotfiles/installed_pkgs > /dev/null || echo $pkg_name >> $HOME/.dotfiles/installed_pkgs); done; }

# A stupid function to latch additional features to removing a package
_remove() { sudo apt remove --purge $@; for pkg_name in $@; do spkg $pkg_name > /dev/null || (grep $pkg_name $HOME/.dotfiles/installed_pkgs > /dev/null && sed -i '/$pkg_name/d' $HOME/.dotfiles/installed_pkgs); done; }

# A stupid alias to reinstall all the packages from the 'installed_pkgs' file
reinstall() { [ -f $HOME/.dotfiles/installed_pkgs ] && cat $HOME/.dotfiles/installed_pkgs | while read -r cmd; do [[ "$cmd" != "#"* ]] && echo $cmd; done || echo "installed_pkgs file doesn't exist"; [ -f $HOME/.dotfiles/myrc ] && cat $HOME/.dotfiles/myrc | while read -r cmd; do [[ "$cmd" != "#"* ]] && echo $cmd; done || echo "myrc file doesn't exist."; }
# reinstall() { if [ -f $HOME/.dotfiles/installed_pkgs ] && [ -f $HOME/.dotfiles/myrc ]; then cat $HOME/.dotfiles/installed_pkgs $HOME/.dotfiles/myrc | while read -r cmd; do [[ "$cmd" != "#"*  ]] && echo $cmd; done; else echo "The backup file is missing. Cannot install necessary packages."; fi; }
# xargs sudo apt install

# Creates a directory and super directories if it doesn't exist
mkifnedir() { [ -d "$@" ] && echo "No need to create directory $@; already exists." || (mkdir -p "$@" && echo "Directory $@ created."); }
export -f mkifnedir

# Creates a file and super directories if it doesn't exist
mkifnefile() { [ -f "$@" ] && echo "No need to create file $@; already exists." || (dir="${$*%/*}" && mkdir -p "$dir" && touch "$@" && echo "File $@ created."); }

# Make C config file for vim spector debugging
dconcpp() { path=`[[ -n $1 ]] && echo $(realpath "$1") || echo $(realpath "$PWD")`; echo -e '{\n\t"configurations": {\n\t\t"Launch": {\n\t\t\t"adapter": "vscode-cpptools",\n\t\t\t"filetypes": [ "cpp", "c", "objc", "rust" ],\n\t\t\t"configuration": {\n\t\t\t\t"request": "launch",\n\t\t\t\t"program": "${workspaceRoot}/main",\n\t\t\t\t"args": [ "debug" ],\n\t\t\t\t"cwd": "${workspaceRoot}",\n\t\t\t\t"environment": [],\n\t\t\t\t"externalConsole": true,\n\t\t\t\t"MIMode": "gdb",\n\t\t\t\t"setupCommands": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"description": "Enable pretty-printing for gdb",\n\t\t\t\t\t\t"text": "-enable-pretty-printing",\n\t\t\t\t\t\t"ignoreFailures": true\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t}\n\t\t},\n\t\t"Attach": {\n\t\t\t"adapter": "vscode-cpptools",\n\t\t\t"filetypes": [ "cpp", "c", "objc", "rust" ],\n\t\t\t"configuration": {\n\t\t\t\t"request": "attach",\n\t\t\t\t"program": "${workspaceRoot}/main",\n\t\t\t\t"MIMode": "gdb"\n\t\t\t}\n\t\t}\n\t}\n}\n' > $path/.vimspector.json; path=; }

dconpy() { path=`[[ -n $1 ]] && echo $(realpath "$1") || echo $(realpath "$PWD")`; echo -e '{\n\t"configurations": {\n\t\t"Python": {\n\t\t\t"adapter": "debugpy",\n\t\t\t"filetypes": [ "python" ],\n\t\t\t"default": true,\n\t\t\t"configuration": {\n\t\t\t\t"request": "launch",\n\t\t\t\t"python": "${VIRTUAL_ENV}/bin/python",\n\t\t\t\t"program": "${workspaceRoot}/${relativeFile}",\n\t\t\t\t"stopOnEntry": true,\n        \t\t"args": [ "/home/mayank/Downloads/NCBI_SRA_Metadata_Full_20210713/NCBI_13/" ],\n\t\t\t\t"cwd": "${workspaceRoot}"\n\t\t\t}\n\t\t}\n\t}\n}\n\n' > $path/.vimspector.json; path=; }

# Only run these commands when running in interactive shell
tty -s && {
	# A stupid command to make Ctrl+S not freeze the terminal
	stty -ixon

	# Stupid bash completetion suggestion
	set show-all-if-ambiguous on
	set show-all-if-unmodified on
	set menu-complete-display-prefix on
	bind '"\t": menu-complete'
	bind '"\e[Z": menu-complete-backward'
	bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'

	# A stupid welcome message
	# -s => Stoned cow. Glazed eyes; tongue out.
	fortune | cowsay -s
}

alias CONNECT_VPN='sudo openvpn --config $HOME/.dotfiles/ibdc-mayank__ssl_vpn_config.ovpn --auth-user-pass $HOME/.dotfiles/openvpn_cred.txt'

PATH=$PATH:/usr/include/c++/11:/usr/include/x86_64-linux-gnu/c++/11
