#  ------------------------------------------------------------------------
#  Key bindings                                                                     
#  ------------------------------------------------------------------------ 
# ctrl+y to accept autosuggestion
bind \cy accept-autosuggestion


#  ------------------------------------------------------------------------
#  Prompt                                                                     
#  ------------------------------------------------------------------------ 
function fish_prompt
    set_color cyan
    echo -n (prompt_pwd)  # prints ~/path
    set_color normal

    # Git branch info
    if test -d .git || git rev-parse --git-dir > /dev/null 2>&1
        set branch (git symbolic-ref --short HEAD ^/dev/null)
        set git_status (git status --porcelain)
        if test -n "$git_status"
            echo -n " $branch*"
        else
            echo -n " $branch"
        end
    end

    echo
    set_color green
    echo -n "❯ "
    set_color normal
end
