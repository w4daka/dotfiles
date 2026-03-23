# w4daka's dotfiles

- shell `zsh` + `sheldon` + `starship`
- editor `neovim`

## 個人的メモ

chezmoiを経由せずに変更したときは`chezmo add ~/hogehoge`する

### chezmoiのパスを通す

```shell
# 1. 受け皿となるディレクトリを作成（既にあれば何もしません）
mkdir -p ~/.local/bin

# 2. 今ある chezmoi を移動
mv ./bin/chezmoi ~/.local/bin/

# 3. 念のため、さっき作られた空の bin ディレクトリを消す
rmdir ./bin 2>/dev/null

# 4. パス設定を反映させる
source ~/.profile
```

### 画面の明るさを変更できようにする

```shell
sudo usermod -aG video $USER
```

をする

### SSH+GithubCLl前提のGit設定のテンプレ

1. SSHキー確認/作成

```shell
# ~/.ssh/id_ed25519 が存在するか確認
ls ~/.ssh/id_ed25519

# 存在しなければ作成
ssh-keygen -t ed25519 -C "my e.mail adress"
```

1. SSHキーをGithubに登録

```shell
# 公開鍵をコピー
cat ~/.ssh/id_ed25519.pub
```

1. Github CLIでGithubに登録

```shell
gh auth login
# ここで SSH を選択
# ブラウザ認証を経て接続確認
```

1. Gitユーザー情報設定(グローバル)

```shell
git config --global user.name w4daka
git config --global user.email "my email address"
```

1. 設定確認

```shell
git config --global user.name
git config --global user.email
```

1. 動作確認

```shell
# SSH接続確認
ssh -T git@github.com
# Git操作確認
git clone git@github.com:w4daka/リポジトリ名.git
```

1. dotfilesリポジトリをsshに変える

```shell
git remote set-url origin git@github.com:w4daka/dotfiles.git
```

### Windowsに戻したいときにやること

1. バックアップファイルの場所

例：古いPCの backup フォルダにある

`\\DESKTOP-NSS35KE\backup\ext4.vhdx`

1. WSL復元の手順

新しいPCや再インストール後にPowerShellで：

```shell
wsl --import Ubuntu_backup C:\WSL\Ubuntu_backup \\DESKTOP-NSS35KE\backup\ext4.vhdx --version 2
```

解説：

Ubuntu_backup → 復元後のWSL名

C:\WSL\Ubuntu_backup → WSLを配置するフォルダ

ext4.vhdx → 先ほどバックアップしたファイル

--version 2 → WSL2で復元

1. 復元後の確認

```shell
wsl -l -v
```

Ubuntu_backup が Running または Stopped 状態で表示される。

1. 起動

```shell
wsl -d Ubuntu_backup
```

これで 元のWSL環境そのまま。
ホームディレクトリ、設定、パッケージすべて復元される。
