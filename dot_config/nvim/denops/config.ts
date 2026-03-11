// import { BaseConfig } from "https://deno.land/x/ddc_vim@v5.0.0/types.ts";
// import { ConfigArguments } from "https://deno.land/x/ddc_vim@v5.0.0/base/config.ts";
//
// export class Config extends BaseConfig {
//     override async config(args: ConfigArguments): Promise<void> {
//         args.contextBuilder.patchGlobal({
//             ui: "pum",
//             autoCompleteEvents: [
//                 "InsertEnter",
//                 "TextChangedI",
//                 "TextChangedP",
//                 "CmdlineEnter",
//                 "CmdlineChanged",
//                 "TextChangedT",
//             ] as const,
//             sources: [
//                 "skkeleton",
//                 "nvim-lsp",
//                 "nextword",
//                 "nvimlua",
//                 "around",
//                 "buffer",
//                 "file"
//             ] as const,
//             sourceOptions: {
//                 "_": {
//                     matchers: ["matcher_head"],
//                     sorters: ["sorter_rank"],
//                     converters: ["converter_remove_overlap"],
//                     minAutoCompleteLength: 1,
//                 },
//                 "nvim-lsp": {
//                     mark: "LSP",
//                     forceCompletionPattern: "\\.\\w*|:\\w*|->\\w*",
//                     dup: "keep",
//                 },
//                 "buffer": { mark: "B" },
//                 "nvim-lua": { mark: "" },
//                 "skkeleton": {
//                     mark: "SKK",
//                     matchers: ["skkeleton"],
//                     isVolatile: true,
//                 },
//                 "nextword": { mark: "NW", isVolatile: true },
//                 "around": { mark: "A" },
//                 "file": {
//                     mark: "F",
//                     isVolatile: true,
//                     forceCompletionPattern: "\\S/\\S*",
//                 },
//             } as const,  // ← ここはカンマOK（まだ } as const); が続くため）
//         } as const);   // ← ここはカンマなし
//
//         // コマンドライン用の設定
//         args.contextBuilder.patchFiletype("cmdline", {
//             sources: ["cmdline", "cmdline-history", "input", "shell-native"],
//             sourceOptions: {
//                 "_": {
//                     keywordPattern: "[0-9a-zA-Z_:#-]*",
//                 },
//             },
//         });
//
//         // skkeleton 固有設定
//         // 古い globalJisyo を削除し、現在の正しいキー名に変更
//         await args.denops.call("skkeleton#config", {
//             globalDictionaries: ["~/.config/dict-skk/SKK-JISYO.L"],  // 配列形式に変更
//             eggLikeNewline: true,
//         });
//     }
// }
