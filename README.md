# w4daka's dotfiles

- shell `zsh` + `sheldon` + `starship`
- editor `neovim`

## 個人的メモ

chezmoiを経由せずに変更したときは`chezmo add ~/hogehoge`する

git configのやり方

1.SSHキー確認/作成

```shell
# ~/.ssh/id_ed25519 が存在するか確認
ls ~/.ssh/id_ed25519

# 存在しなければ作成
ssh-keygen -t ed25519 -C "自分のメールアドレス"
```

2.SSHキーをgithubに登録

````shell
# 公開鍵をコピー
cat ~/.ssh/id_ed25519.pub
````

3.GithubCLIで認証

````shell
gh auth login
# ここで SSH を選択
# ブラウザ認証を経て接続確認
````

4.Gitユーザー情報設定(グローバル)

````shell
git config --global user.name w4daka
git config --global user.email 自分のメアド
````

5.設定確認

````shell
git config --global user.name
git config --global user.email
````

6.動作確認

````shell
# SSH接続確認
ssh -T git@github.com
# Git操作確認
git clone git@github.com:w4daka/リポジトリ名.git
````

7.dotfilesリポジトリをsshに変更

````shell
git remote set-url origin git@github.com:w4daka/dotfiles.git
````
