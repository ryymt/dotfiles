# パス設定
export PATH=~/bin:$PATH
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

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

#Boxパス
alias BOXBKUP/='/Users/Ryu/Library/CloudStorage/Box-Box/CMA-制作部/バックアップ'

# 接尾辞エイリアス 拡張子と起動アプリケーションを紐付け
alias -s pdf=xpdf

# ls
alias ls='ls -AGF'

# zmv
alias zmv='noglob zmv -W'

# cdの後にlsを実行
chpwd() {
 if [[ $(pwd) != $HOME ]]; then;
   ls
 fi
}

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

# sheldon
eval "$(sheldon source)"