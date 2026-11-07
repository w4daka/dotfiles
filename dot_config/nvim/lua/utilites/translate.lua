return {
  'niuiic/translate.nvim',
  dependencies = {
    'niuiic/omega.nvim',
  },

  config = function()
    -- LTEngine (LibreTranslate互換) のエンドポイント。
    -- 0.0.0.0はサーバ側のbindアドレスなので、クライアントからは127.0.0.1で叩く。
    -- 環境変数 LTENGINE_URL で上書き可。例: export LTENGINE_URL=http://192.168.1.10:5050/translate
    local ltengine_url = vim.env.LTENGINE_URL or 'http://127.0.0.1:5050/translate'

    ---@param stdout string
    local function trim(stdout)
      return (stdout:gsub('^%s+', ''):gsub('%s+$', ''))
    end

    local function resolve_result(result)
      if result.code ~= 0 then
        vim.notify(
          'LTEngine request failed: '
            .. trim(result.stderr ~= '' and result.stderr or result.stdout),
          vim.log.levels.ERROR,
          { title = 'Translate' }
        )
        return nil
      end
      local ok, data = pcall(vim.json.decode, result.stdout)
      if not ok or type(data) ~= 'table' or not data.translatedText then
        vim.notify(
          'unexpected LTEngine response: ' .. trim(result.stdout),
          vim.log.levels.ERROR,
          { title = 'Translate' }
        )
        return nil
      end
      return trim(data.translatedText)
    end

    ---@param source string 'en' | 'ja' | 'auto'
    ---@param target string 'ja' | 'en'
    ---@param output string[]
    local function translate(source, target, output)
      require('translate').translate({
        get_command = function(input)
          if input == nil or trim(input) == '' then
            return { 'printf', '{"translatedText":""}' }
          end
          return {
            'curl',
            '-s',
            '--max-time',
            '30',
            '-X',
            'POST',
            ltengine_url,
            '-H',
            'Content-Type: application/json',
            '-d',
            vim.json.encode({ q = input, source = source, target = target, format = 'text' }),
          }
        end,
        input = 'selection',
        output = output or { 'open_float' },
        resolve_result = function(result)
          local ok, data = pcall(vim.json.decode, result.stdout)
          if ok and data.translatedText == '' then
            vim.notify('No selection', vim.log.levels.WARN, { title = 'Translate' })
            return nil
          end
          return resolve_result(result)
        end,
      })
    end

    -- NOTE: 言語コードはISO 639-1。日本語は 'jp' ではなく 'ja'。
    -- 対応コード一覧: curl -s http://127.0.0.1:5050/languages | jq
    vim.keymap.set('v', '<leader>tj', function()
      translate('en', 'ja', { 'open_float' })
    end, { desc = 'translate en->ja (LTEngine)' })
    vim.keymap.set('v', '<leader>te', function()
      translate('ja', 'en', { 'open_float' })
    end, { desc = 'translate ja->en (LTEngine)' })
  end,
}
