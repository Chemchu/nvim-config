{ config, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = config.plugins.git-worktree;
in
{

  plugins = {
    git-worktree = {
      enable = true;
      enableTelescope = true;
    };

    which-key.settings.spec = lib.optionals (cfg.enableTelescope && cfg.enable) [
      {
        __unkeyed = "<leader>gW";
        group = "󰙅 Worktree";
      }
    ];
  };

  keymaps = mkIf cfg.enableTelescope [
    {
      mode = "n";
      key = "<leader>fg";
      action = ":Telescope git_worktree<CR>";
      options = {
        desc = "Git Worktree";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>gWc";
      action.__raw = # Lua
        ''
          function()
            require('telescope').extensions.git_worktree.create_git_worktree()
          end
        '';
      options = {
        desc = "Create worktree";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>gWs";
      action.__raw = # Lua
        ''
          function()
            require('telescope').extensions.git_worktree.git_worktrees()
          end
        '';
      options = {
        desc = "Switch / Delete worktree";
        silent = true;
      };
    }
  ];
}
