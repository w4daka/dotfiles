# w4daka's dotfiles

- shell `zsh` + `sheldon` + `starship`
- editor `neovim`

## 個人的メモ

chezmoiを経由せずに変更したときは`chezmo add ~/hogehoge`する

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
ssh-keygen -t ed25519 -C "ignorenegativeideology999@gmail.com"
```

2. SSHキーをGithubに登録

```shell
# 公開鍵をコピー
cat ~/.ssh/id_ed25519.pub
```

3. Github CLIでGithubに登録

```shell
gh auth login
# ここで SSH を選択
# ブラウザ認証を経て接続確認
```

4. Gitユーザー情報設定(グローバル)

```shell
git config --global user.name w4daka
git config --global user.email ignorenegativeideology999@gmail.com
```

5. 設定確認

```shell
git config --global user.name
git config --global user.email
```

6. 動作確認

```shell
# SSH接続確認
ssh -T git@github.com
# Git操作確認
git clone git@github.com:w4daka/リポジトリ名.git
```

7. dotfilesリポジトリをsshに変える

```shell
git remote set-url origin git@github.com:w4daka/dotfiles.git
```
