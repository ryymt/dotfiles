# パス設定
export PATH=~/bin:$PATH
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
# export PATH=/usr/local/bin/git:$PATH
# export PATH="/opt/homebrew/bin/rsync:$PATH"

# 補完
autoload -Uz compinit
compinit

# zmv
autoload -U zmv

# メモリに保存される履歴の件数
export HISTSIZE=1000

# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000

# 重複を記録しない
setopt hist_ignore_dups

# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups

# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space

# cd省略
setopt auto_cd

# 補完キー連打で順に補完候補を自動で補完
setopt auto_menu

# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

# ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt mark_dirs

# コマンドミスを修正
setopt correct

# 拡張パターン
setopt extended_glob

# Ctrl+sのロック, Ctrl+qのロック解除を無効にする
setopt no_flow_control

# 補完で大文字にもマッチ
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完に隠しファイルも表示
setopt globdots

# alias ---------

#　よく使う階層
alias boxbkup='~/Library/CloudStorage/Box-Box/CMA-制作部/バックアップ'
alias prj='~/Project'
alias dwn='~/Downloads'

# 年月日時分秒フォルダを作成
alias mkdtfolder='mkdir "$(date '+%Y-%m-%d-%H-%M-%S')"'

# 接尾辞エイリアス 拡張子と起動アプリケーションを紐付け
alias -s pdf=xpdf

# ls
alias ls='ls -AGF'

# zmv
# alias zmv='noglob zmv -W'

# git関連
# リリース用のGitタグを作成してプッシュする
function git-release() {
    if [ -z "$1" ]; then
        echo "使用法: git-release <ブランチ名>"
        return 1
    fi
    tname="release-$1"
    git tag "$tname" && git push origin "$tname"
}
# ブランチ削除関数
function git-branch-delete() {
  local branch="$1"

  if [[ -z "$branch" ]]; then
    echo "Usage: git-branch-delete <branch-name>"
    return 1
  fi

  # 確認プロンプト
  echo "⚠️ 本当にブランチ '${branch}' をローカル・リモート両方から削除しますか？ (y/n)"
  read -r ans
  case "$ans" in
    y|Y )
      # ローカル削除
      git branch -d "$branch" 2>/dev/null || git branch -D "$branch"

      # リモート削除
      git push origin --delete "$branch"
      echo "ゴミ箱 ブランチ '${branch}' を削除しました。"
      ;;
    * )
      echo "キャンセルしました。"
      ;;
  esac
}

# cdの後にlsを実行
chpwd() {
 if [[ $(pwd) != $HOME ]]; then;
   ls
 fi
}
# colordiff
if [[ -x `which colordiff` ]]; then
  alias diff='colordiff'
fi

#ls色設定
export LSCOLORS=cxfxcxdxbxegedabagacad

# pdf 圧縮
function pdfmin()
{
    local cnt=0
    for i in $@; do
        gs -sDEVICE=pdfwrite \
           -dCompatibilityLevel=1.4 \
           -dPDFSETTINGS=/ebook \
           -dNOPAUSE -dQUIET -dBATCH \
           -sOutputFile=${i%%.*}.min.pdf ${i} &
        (( (cnt += 1) % 4 == 0 )) && wait
    done
    wait && return 0
}

# z
. `brew --prefix`/etc/profile.d/z.sh

# fzf prompt
function fzf-select-history() {
    BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER" --reverse)
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

# fzf git branch
export FZF_DEFAULT_OPTS="--reverse --no-sort --no-hscroll --preview-window=down"

user_name=$(git config user.name)
fmt="\
%(if:equals=$user_name)%(authorname)%(then)%(color:default)%(else)%(color:brightred)%(end)%(refname:short)|\
%(committerdate:relative)|\
%(subject)"
function select-git-branch-friendly() {
  selected_branch=$(
    git branch --sort=-committerdate --format=$fmt --color=always \
    | column -ts'|' \
    | fzf --ansi --exact --preview='git log --oneline --graph --decorate --color=always -50 {+1}' \
    | awk '{print $1}' \
  )
  BUFFER="${LBUFFER}${selected_branch}${RBUFFER}"
  CURSOR=$#LBUFFER+$#selected_branch
  zle redisplay
}
zle -N select-git-branch-friendly
bindkey '^b' select-git-branch-friendly

# fzf z ディレクトリ
function fzf-cdr() {
    local selected_dir=$(z -tl | cut -c 12- | fzf --prompt="Dir> " --tac)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
        zle clear-screen
     else
        zle redisplay
    fi
}
zle -N fzf-cdr
bindkey '^g^f' fzf-cdr

# sheldon
eval "$(sheldon source)"

# zoxide
eval "$(zoxide init zsh)"

# bun completions
[ -s "/Users/Ryu/.bun/_bun" ] && source "/Users/Ryu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/Ryu/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
