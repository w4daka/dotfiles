-- ~/.config/nvim/lua/snippets/english.lua

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node

-- 選択テキスト取得（なければ空）
local function get_selected(_, snip)
  return snip.env.TM_SELECTED_TEXT or { "" }
end

ls.add_snippets("markdown", {
  -- 基本テンプレ
  s("ses", {
    t("# sentence: "),
    i(1),
    t({ "", "## syntax: " }),
    i(2),
    t({ "", "## sturcture: " }),
    i(3),
    t({ "", "## tag: " }),
    i(4),
    t({ "", "## tag: " }),
    i(5),
    t({ "", "## tag: " }),
    i(6),
    t({ "", "## decision: " }),
    i(7),
    t({ "", "## mistake: " }),
    i(0),
  }),

  -- 選択テキストをsentenceに入れる版
  s("sess", {
    t("sentence: "),
    f(get_selected, {}),
    t({ "", "syntax: " }),
    i(1),
    t({ "", "pattern: " }),
    i(2),
    t({ "", "tags: " }),
    i(3),
    t({ "", "decision: " }),
    i(4),
    t({ "", "mistake: " }),
    i(5),
    t({ "", "# " }),
    i(0),
  }),
})
