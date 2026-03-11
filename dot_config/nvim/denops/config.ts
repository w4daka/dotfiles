import { BaseConfig } from "https://deno.land/x/ddc_vim@v5.0.0/types.ts";
import { ConfigArguments } from "https://deno.land/x/ddc_vim@v5.0.0/base/config.ts";

export class Config extends BaseConfig {
    override async config(args: ConfigArguments): Promise<void> {
        args.contextBuilder.patchGlobal({
            ui: "pum",
            autoCompleteEvents: [
                "InsertEnter",
                "TextChangedI",
                "TextChangedP",
                "CmdlineEnter",
                "CmdlineChanged",
                "TextChangedT",
            ],
            sources: [
                "skkeleton",
                "nvim-lsp",
                "nextword",
                "nvimlua", // nvim-lua
                "around",
                "buffer",
                "file"
            ],
            sourceOptions: {
                "_": {
                    matchers: ["matcher_head"],
                    sorters: ["sorter_rank"],
                    converters: ["converter_remove_overlap"],
                    minAutoCompleteLength: 1,
                },
                "nvim-lsp": {
                    mark: "LSP",
                    forceCompletionPattern: "\\.\\w*|:\\w*|->\\w*",
                    dup: "keep",
                },
                buffer: {
                    mark: "B"
                }
        "nvim-lua": {
                    mark: "",
                    forceCompletionPattern: "\\.\\w*",
                }
        skkeleton: {
                    mark: "SKK",
                    matchers: ["skkeleton"],
                    isVolatile: true,
                },
                nextword: {
                    mark: "NW",
                    isVolatile: true,
                },
                nvimlua: { mark: "LUA" },
                around: { mark: "A" },
                buffer: { mark: "B" },
                file: {
                    mark: "F",
                    isVolatile: true,
                    forceCompletionPattern: "\\S/\\S*",
                },
            },
        });

        // コマンドライン用の設定
        args.contextBuilder.patchFiletype("cmdline", {
            sources: ["cmdline", "cmdline-history", "input", "shell-native"],
            sourceOptions: {
                "_": {
                    keywordPattern: "[0-9a-zA-Z_:#-]*",
                },
            },
        });

        // skkeleton 固有設定
        await args.denops.call("skkeleton#config", {
            globalJisyo: "~/.config/dict-skk/SKK-JISYO.L",
            eggLikeNewline: true,
        });
    }
}
