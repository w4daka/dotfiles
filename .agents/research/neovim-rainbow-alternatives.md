# Neovim rainbow parentheses 代替プラグイン調査

結論: Neovim現役なら HiPhish/rainbow-delimiters.nvim が第一候補（Tree-sitter必須、活発にメンテ）。Vim8互換・Tree-sitter不要なら luochen1990/rainbow 継続が最良。p00f/nvim-ts-rainbow 系は全てアーカイブ済みで新規導入不可。frazrepo/junegunn/kien は2018年以前停止のレガシー。

基準プラグイン: luochen1990/rainbow — 正規表現+syntax region方式、レベル無制限、guifgs/ctermfgs分離、言語別・演算子含むJSON風設定、Vim/Neovim両対応・Tree-sitter不要。
- https://github.com/luochen1990/rainbow
- https://github.com/luochen1990/rainbow/blob/master/README.md
- https://github.com/luochen1990/rainbow/blob/master/autoload/rainbow.vim （`start=... step=... end=...` のsyntax region動的生成を確認）

## 候補一覧

### 1. HiPhish/rainbow-delimiters.nvim（現役・推奨）
- URL: https://github.com/HiPhish/rainbow-delimiters.nvim
- 状態: 最終push 2026-10-05、open issues 19、非アーカイブ（APIで動作確認済み）。README.rstとdoc/rainbow-delimiters.txt（v0.12.0）あり。
- 対応: Neovim専用、Tree-sitter必須（各言語パーサが必要）。Vim8不可。
- 仕組み: Tree-sitterクエリ＋strategy（global/local）でハイライト。`g:rainbow_delimiters` で strategy/query/priority/highlight をグローバル・言語別に上書き可能。
- luochenとの差: 括弧の対応ではなく構文木ノード対応のためHTMLタグ・Lua do/end等も染め分け可（docのINTROに明記）。言語別クエリ拡張・カスタムstrategyが公式サポート。反面、パーサ未導入言語では動作しない。
- ソース:
  - https://github.com/HiPhish/rainbow-delimiters.nvim
  - https://raw.githubusercontent.com/HiPhish/rainbow-delimiters.nvim/master/README.rst
  - https://raw.githubusercontent.com/HiPhish/rainbow-delimiters.nvim/master/doc/rainbow-delimiters.txt
- 向き: Neovim＋Tree-sitter運用中の現行構成向け。不向き: Vim8併用・Tree-sitterを入れたくない環境。

### 2. p00f/nvim-ts-rainbow（終了・アーカイブ）
- URL: https://github.com/p00f/nvim-ts-rainbow （実体は dchinmay2/nvim-ts-rainbow に移管・archived:true）
- 状態: push 2023-01-02で停止、アーカイブ済み。README先頭に「NO LONGER MAINTAINED」明記。
- 対応: Neovim nightly＋nvim-treesitterモジュール（単体プラグインではない）。Vim8不可。
- 仕組み: Tree-sitterベース。`rainbow = { enable, extended_mode, max_file_lines, colors }` をnvim-treesitter setup経由で設定。extended_modeでHTMLタグ等も対象。
- luochenとの差: 言語別設定はdisableリスト・色指定程度で、luochenほど細かい括弧定義は不可。パフォーマンスはTree-sitter依存。
- ソース:
  - https://github.com/p00f/nvim-ts-rainbow
  - https://raw.githubusercontent.com/dchinmay2/nvim-ts-rainbow/master/README.md
- 向き: 既存利用者の移行元としてのみ参照。新規導入は不向き（後継はHiPhish系へ）。

### 3. HiPhish/nvim-ts-rainbow2（終了・前身）
- URL: https://github.com/HiPhish/nvim-ts-rainbow2
- 状態: push 2024-05-21で停止。rainbow-delimiters.nvimのREADMEに「nvim-treesitterがモジュール制を廃止したためforkし直した」と明記。
- 対応: Neovim＋nvim-treesitterモジュール時代のもの。
- ソース: https://github.com/HiPhish/nvim-ts-rainbow2 ／ https://github.com/HiPhish/rainbow-delimiters.nvim （README.rstのforks言及）
- 向き: 経緯理解用。不向き: 新規導入（rainbow-delimiters.nvimを使 directly）。

### 4. mrjones2014/nvim-ts-rainbow（フォーク・停止）
- URL: https://github.com/mrjones2014/nvim-ts-rainbow
- 状態: push 2023-06-07、archived:true。p00f系フォーク中最多スター（172）だが停止。
- ソース: https://api.github.com/repos/mrjones2014/nvim-ts-rainbow
- 向き: 不向き（停止済み）。現役フォークは確認できず。

### 5. frazrepo/vim-rainbow（停止・luochen系fork）
- URL: https://github.com/frazrepo/vim-rainbow
- 状態: push 2019-01-13、archived:true。README冒頭でoblitum/rainbow（＝luochen系）のforkと明記。
- 対応: Vim用、正規表現/syntax方式、Tree-sitter不要。
- luochenとの差: 括弧外演算子の常時ハイライト化、C++/Rust/C#/Java向け`<>`追加、デフォルト色をgruvbox流用。設定形式はluochen互換（`g:rainbow_active`）。
- ソース:
  - https://github.com/frazrepo/vim-rainbow
  - https://raw.githubusercontent.com/frazrepo/vim-rainbow/master/README.md
- 向き: luochen既定色が合わない人向けだったが停止済みのため不向き。継続利用はluochen本家へ。

### 6. junegunn/rainbow_parentheses.vim（停止・シンプル系）
- URL: https://github.com/junegunn/rainbow_parentheses.vim
- 状態: push 2018-06-13、非アーカイブだが実質停止。kienからのheavy-rewrite forkとREADME明記。
- 対応: Vim用、Tree-sitter不要。`:RainbowParentheses` 系コマンド＋ `g:rainbow#max_level`（既定16）・`g:rainbow#pairs`・blacklist設定。
- luochenとの差: レベル上限あり（luochenは無制限）、言語別括弧定義なし、カラースキーム変更時の自動追従あり。
- ソース:
  - https://github.com/junegunn/rainbow_parentheses.vim
  - https://raw.githubusercontent.com/junegunn/rainbow_parentheses.vim/master/README.md
- 向き: 設定最小・Lisp系のみ染めたい人向けだったが停止済み。不向き: 多言語・細粒度設定。

### 7. kien/rainbow_parentheses.vim（停止・元祖系）
- URL: https://github.com/kien/rainbow_parentheses.vim
- 状態: push 2017-06-14、実質停止。`g:rbpt_colorpairs`（16ペア）・`g:rbpt_max = 16`・Toggle/Load系コマンド。
- 対応: Vim用、Tree-sitter不要。
- luochenとの差: 16レベル上限、言語別設定なし、色はcterm/guiペア固定。
- ソース:
  - https://github.com/kien/rainbow_parentheses.vim
  - https://raw.githubusercontent.com/kien/rainbow_parentheses.vim/master/readme.md
- 向き: 歴史的参照のみ。新規導入は不向き。

## 比較表

| プラグイン | メンテ | Vim8 | Neovim | TS要否 | 方式 | 言語別設定 |
|---|---|---|---|---|---|---|
| luochen1990/rainbow | 2024-07-27 push・継続（未アーカイブ） | ○ | ○ | 不要 | syntax region | ◎（括弧・色・演算子） |
| rainbow-delimiters.nvim | 現役（2026-10-05 push） | × | ○ | 必須 | Tree-sitter | ◎（query/strategy） |
| p00f/nvim-ts-rainbow | 終了（2023、アーカイブ） | × | ○ | 必須 | Tree-sitter | △ |
| nvim-ts-rainbow2/mrjones fork | 終了 | × | ○ | 必須 | Tree-sitter | △ |
| frazrepo/vim-rainbow | 終了（2019、アーカイブ） | ○ | ○ | 不要 | syntax | ○（luochen互換） |
| junegunn | 停止（2018） | ○ | ○ | 不要 | syntax | × |
| kien | 停止（2017） | ○ | ○ | 不要 | syntax | × |

## 推奨
- Neovim＋Tree-sitter常用 → HiPhish/rainbow-delimiters.nvim。
- Vim8併用・軽量維持 → luochen1990/rainbow継続（最終push 2024-07-27、未アーカイブで5候補中最も新しい非TS系）。
- p00f系・frazrepo・junegunn・kienは新規導入しない。

## 未確認事項
- 未確認：luochen1990/rainbowのNeovim 0.10+での動作uncan（手元にNeovimなし、CIも未参照）。
- 未確認：rainbow-delimiters.nvimのqueryが対応する全言語一覧（queries/ディレクトリの実測一覧未取得）。
- 未確認：各プラグインの実測パフォーマンス比較（大ファイルでの計測なし）。
