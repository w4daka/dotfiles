-- ============================================================================
-- custom.lua — お兄ちゃんと凛の「差分」だけを置くファイル
-- 作成: 2026-11-07 / 対象: Hyprland 0.57.0（設定言語は Lua）
--
-- ■ なぜ hyprland.lua を直接いじらないのか
--   hyprland.lua は Hyprland が自動生成したサンプル。直接書き換えると
--   ・どの行が「自分で決めた設定」なのか分からなくなる
--   ・Hyprland のサンプルが更新されたときに衝突する
--   ・壊したときに、どこまで戻せばいいか分からない
--   そこで「最後に読み込まれるファイル」を1枚だけ用意し、変更はここに集める。
--
-- ■ なぜ上書きできるのか
--   Hyprland は設定を読んだ順に適用し、同じ項目は後から読んだ値が勝つ。
--   このファイルは hyprland.lua の最後に読まれるので、本体の上に重ねられる。
--   ＝上書き層。剥がしたければ require の1行を消すだけで元に戻る。
--
-- ■ 読み込ませ方（1回だけ）
--   hyprland.lua の末尾に次の1行を足す:
--       require("custom")
--   ~/.config/hypr は require の探索パスに入っているので、
--   ~/.config/hypr/custom.lua はそのまま "custom" で見つかる。
--
-- ■ 書き方の基本
--   hl.bind("修飾キー + キー", ディスパッチャ, { オプション })
--   hl.config({ セクション = { 項目 = 値 } })   -- 渡した分だけ更新される
--   hl.dsp.* は「動作の説明書」を作るだけで、単体では何も起きない。
--   bind に渡すか hl.dispatch() に入れて初めて実行される。
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1) ウィンドウを方向つきで移動する  SUPER + SHIFT + H / J / K / L
-- ----------------------------------------------------------------------------
-- 似た命令が2つあるので区別する:
--   hl.dsp.focus({ direction = ... })       見ている場所（フォーカス）を動かす
--   hl.dsp.window.move({ direction = ... }) 窓そのものを隣と入れ替える
-- 5月の hyprland.conf には movewindow があったが、Lua へ移したときに消えていた。
--
-- キーと方向の対応表を作って for で回す。10行書く代わりに数行で済み、
-- あとからキーを足すときも表に1行足すだけでよい。
local move_keys = { H = "left", J = "down", K = "up", L = "right" }
local direction_jp = { left = "左", right = "右", up = "上", down = "下" }

for key, direction in pairs(move_keys) do
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }), {
		description = "ウィンドウ: " .. direction_jp[direction] .. "へ移動",
	})
end

-- ----------------------------------------------------------------------------
-- 2) フルスクリーン切替  SUPER + F
-- ----------------------------------------------------------------------------
-- mode = "fullscreen" はバーも含めて全画面（本物のフルスクリーン）。
-- mode = "maximized" にするとバーを残したまま最大化。ここでは前者を選んでいる。
-- action は "toggle"（切替）/ "set"（入る）/ "unset"（出る）の3種類。
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), {
	description = "ウィンドウ: フルスクリーン切替",
})

-- ----------------------------------------------------------------------------
-- 3) 設定の手動リロード  SUPER + SHIFT + C
-- ----------------------------------------------------------------------------
-- 0.57 はファイルの変更を自動で拾うが、自動が効かない場面のために手で呼べるようにする
-- （hyprctl eval で実験したあと、別マシンから編集したとき、など）。
-- exec_cmd("hyprctl reload") でも同じだが、専用のディスパッチャが用意されている。
hl.bind("SUPER + SHIFT + C", hl.dsp.reload_config(), {
	description = "設定: リロード",
})

-- ----------------------------------------------------------------------------
-- 4) リサイズモード  SUPER + R → H / J / K / L で拡縮、Enter か Esc で抜ける
-- ----------------------------------------------------------------------------
-- submap は「一時的に別のキーマップに切り替える」仕組み。
--   入る: hl.dsp.submap("resize")
--   出る: hl.dsp.submap("reset")
-- repeating = true は「押しっぱなしで連続実行」の指定。
--
-- 注意: 抜けるキーを必ず用意する。無いと閉じ込められて端末も開けなくなる。
-- 閉じ込められたら、別のTTYから
--   hyprctl dispatch 'hl.dsp.submap("reset")'
-- で脱出できる。
hl.bind("SUPER + R", hl.dsp.submap("resize"), { description = "リサイズ: モード開始" })

hl.define_submap("resize", function()
	-- x は幅、y は高さ。relative = true が「今の大きさからの増減」の意味。
	-- マイナスで縮む。1回あたり30px。
	hl.bind("H", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
	hl.bind("L", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
	hl.bind("K", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
	hl.bind("J", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })

	hl.bind("Return", hl.dsp.submap("reset"))
	hl.bind("Escape", hl.dsp.submap("reset"))
end)

-- ----------------------------------------------------------------------------
-- 5) 全画面スクリーンショット  ALT + SHIFT + S
-- ----------------------------------------------------------------------------
-- 範囲指定版（SUPER + SHIFT + S）は hyprland.lua 側に既にあるので、
-- こちらは「画面そのまま全部」を撮る版。
-- exec_cmd は sh -c で実行されるので、$HOME や $(date ...) は実行時に展開される。
-- そのため、コマンド全体を二重引用符ではなく一重引用符で囲む（Lua に展開させない）。
hl.bind(
	"ALT + SHIFT + S",
	hl.dsp.exec_cmd(
		'mkdir -p "$HOME/Pictures/Screenshots" && grim "$HOME/Pictures/Screenshots/Screenshot-$(date +%F_%T).png" && notify-send -t 1500 "スクショを保存しました"'
	),
	{ description = "画面: 全画面スクリーンショット" }
)

-- ----------------------------------------------------------------------------
-- 6) 起動画面のロゴを消す（5月の hyprland.conf にあった設定）
-- ----------------------------------------------------------------------------
-- hyprland.lua 側は disable_hyprland_logo = false（＝ロゴを出す）になっている。
-- disable_splash_rendering は「画面の隅に出る小さな文字」を消す設定。
hl.config({
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
})

-- ----------------------------------------------------------------------------
-- 7)（おまけ）スピーカーのミュートを SUPER + ALT + N へ
-- ----------------------------------------------------------------------------
-- 理由: hyprland.lua の 333行目と 338行目で SUPER + ALT + M が2回定義されていて、
-- 後ろ（マイク）が勝ち、スピーカーのミュートは押しても効かない状態だった。
-- 本体を書き換えず、空いているキーに同じ動作を足して回避する。
hl.bind("SUPER + ALT + N", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), {
	locked = true,
	description = "音量: スピーカーのミュート切替",
})
