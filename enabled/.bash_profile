echo "in .bash_profile"
# ~/.bash_profile: executed by the command interpreter for login shells.

# Because of this file's existence, neither ~/.bash_login nor ~/.profile
# will be sourced.

# See /usr/share/doc/bash/examples/startup-files for examples.
# The files are located in the bash-doc package.

# added during first install 2022-10-23
if [[ $(uname) == 'Darwin' ]]; then
    export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:"/Applications/Little Snitch.app/Contents/Components"
    [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
fi

# Because ~/.profile isn't invoked if this files exists,
# we must source ~/.profile to get its settings:
if [ -r ~/.profile ]; then . ~/.profile; fi

# The following sources ~/.bashrc in the interactive login case,
# because .bashrc isn't sourced for interactive login shells:
#case "$-" in *i*) if [ -r ~/.bashrc ]; then . ~/.bashrc; fi;; esac

# I'm still trying to wrap my head about what to put here.  A suggestion
# would be to put all the `bash` prompt coloring sequence functions as
# described on http://brettterpstra.com/2009/11/17/my-new-favorite-bash-prompt/

# also https://superuser.com/questions/703415/why-do-people-source-bash-profile-from-bashrc-instead-of-the-other-way-round

#export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
source $NVM_DIR/nvm.sh
#[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && \. "/usr/local/opt/nvm/etc/bash_completion"

# Created by `pipx` on 2024-03-18 09:27:16
export PATH="$PATH:/Users/julien/.local/bin"
