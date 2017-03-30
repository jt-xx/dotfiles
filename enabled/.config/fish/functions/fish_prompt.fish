function fish_prompt --description "Write out the prompt"
    # Just calculate this once, to save a few cycles when displaying the prompt
    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
    end

    set -l color_cwd
    set -l suffix
    switch $USER
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '>'
    end

    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_color_branch magenta
    set -g __fish_git_prompt_color_dirtystate 06f
    set -g __fish_git_prompt_char_dirtystate "+"
    set -g __fish_git_prompt_color_cleanstate green

    echo -en -s "$USER" @ "$__fish_prompt_hostname" ' ' (set_color $color_cwd) (prompt_pwd) (set_color normal) (__fish_git_prompt) "\n$suffix "
end

#set -g __fish_git_prompt_show_informative_status 1
#set -g __fish_git_prompt_hide_untrackedfiles 1
#
#set -g __fish_git_prompt_color_branch magenta '--bold'
#set -g __fish_git_prompt_showupstream "informative"
#set -g __fish_git_prompt_char_upstream_ahead "↑"
#set -g __fish_git_prompt_char_upstream_behind "↓"
#set -g __fish_git_prompt_char_upstream_prefix ""
#
#set -g __fish_git_prompt_char_stagedstate "●"
#set -g __fish_git_prompt_char_dirtystate "✚"
#set -g __fish_git_prompt_char_untrackedfiles "…"
#set -g __fish_git_prompt_char_conflictedstate "✖"
#set -g __fish_git_prompt_char_cleanstate "✔"
#
#set -g __fish_git_prompt_color_dirtystate blue
#set -g __fish_git_prompt_color_stagedstate yellow
#set -g __fish_git_prompt_color_invalidstate red
#set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
#set -g __fish_git_prompt_color_cleanstate green '--bold'
#
#set -g __fish_git_prompt_showdirtystate 'yes'
#set -g __fish_git_prompt_showstashstate 'yes'
#set -g __fish_git_prompt_showuntrackedfiles 'yes'
#set -g __fish_git_prompt_showupstream 'yes'
