set PATH /usr/local/sbin $PATH ~/bin

switch (uname)
case Darwin
    set PATH /Applications/Postgres.app/Contents/Versions/9.4/bin $PATH
    set PATH /usr/local/opt/findutils/libexec/gnubin /usr/local/opt/coreutils/libexec/gnubin $PATH

    # fix warning on macOS
    set LC_CTYPE en_US.UTF-8
    set LC_ALL en_US.UTF-8
case Linux
case '*'
end

set --export PYTHONSTARTUP ~/.pythonrc

# fish prompt
set fish_prompt_pwd_dir_length 0

# aliases
function l --description "List contents of directory using long format"
    ls -la $argv
end

function u
    cd ..
end
