{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}:
{
  extraPlugins = lib.mkIf config.plugins.blink-cmp.enable (
    with pkgs;
    [
      khanelivim.blink-compat
      khanelivim.blink-emoji
      vimPlugins.blink-cmp-copilot
    ]
  );

  plugins = lib.mkMerge [
    {
      blink-cmp = {
        enable = true;
        package = inputs.blink-cmp.packages.${system}.default;
        luaConfig.pre = # lua
          ''
            require('blink.compat').setup({debug = true, impersonate_nvim_cmp = true})
          '';

        settings = {
          completion = {
            accept.auto_brackets.enabled = true;
            ghost_text.enabled = true;
            documentation = {
              auto_show = true;
              window.border = "rounded";
            };
            menu = {
              border = "rounded";
              draw = {
                columns = [
                  {
                    __unkeyed-1 = "label";
                  }
                  {
                    __unkeyed-1 = "kind_icon";
                    __unkeyed-2 = "kind";
                    gap = 1;
                  }
                  { __unkeyed-1 = "source_name"; }
                ];
              };
            };
          };
          fuzzy = {
            prebuilt_binaries = {
              download = false;
              ignore_version_mismatch = true;
            };
          };
          appearance = {
            use_nvim_cmp_as_default = true;
          };
          keymap = {
            preset = "enter";
            "<A-Tab>" = [
              "snippet_forward"
              "fallback"
            ];
            "<A-S-Tab>" = [
              "snippet_backward"
              "fallback"
            ];
            "<Tab>" = [
              "select_next"
              "fallback"
            ];
            "<S-Tab>" = [
              "select_prev"
              "fallback"
            ];
          };
          signature = {
            enabled = true;
            window.border = "rounded";
          };
          sources = {
            default = [
              # BUILT-IN SOURCES
              "buffer"
              "lsp"
              "luasnip"
              "path"
              "snippets"
              # Community
              "copilot"
              "emoji"
            ];
            providers = {
              # BUILT-IN SOURCES
              lsp.score_offset = 4;
              # Community sources
              copilot = {
                name = "copilot";
                module = "blink-cmp-copilot";
                score_offset = 5;
              };
              emoji = {
                name = "Emoji";
                module = "blink-emoji";
                score_offset = 1;
              };
            };
          };
        };
      };
    }
    (lib.mkIf config.plugins.blink-cmp.enable {
      cmp-calc.enable = false;
      cmp-git.enable = false;
      #cmp-nixpkgs_maintainers.enable = true;
      # cmp-npm.enable = true;
      cmp-spell.enable = false;
      # cmp-treesitter.enable = true;
      cmp-zsh.enable = false;

      lsp.capabilities = # Lua
        ''
          capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
        '';
    })
  ];
}
