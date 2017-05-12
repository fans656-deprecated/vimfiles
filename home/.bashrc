# general
export PS1="\w$ "

alias ll="ls -lh"
alias sb=". ~/.bashrc"
alias eb="vim ~/.bashrc"

# douban
alias h1="cd /home/liuwenlong"
alias h2="cd /home2/liuwenlong"

alias rs21="rsync -av /home2/liuwenlong/log-monitor/ /home/liuwenlong/log-monitor/"
alias rs12="rsync -av --max-size=1m /home/liuwenlong/log-monitor/ /home2/liuwenlong/log-monitor/"

function h2cwd() {
    return '/home' $(pwd)
}
