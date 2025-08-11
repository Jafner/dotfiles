{
  pkgs,
  lib,
  username,
  ...
}: {
  home-manager.users."${username}" = {
    programs.zsh.envExtra = ''
      OPENROUTER_API_KEY=$(cat /home/joey/.keys/openrouter/zed)
    '';
    home.packages = with pkgs; [
      nixd
      sops
      alejandra
    ];

    programs.zed-editor = {
      enable = true;
      extensions = [
        "Nix"
        "Catppuccin"
      ];
      userSettings = {
        tab_size = 2;
        languages."Nix" = {
          "show_completion_documentation" = true;
          "show_completions_on_input" = true;
          "show_edit_predictions" = true;
          "format_on_save" = "on";
          "formatter".external = {
            "command" = "alejandra";
            "args" = [];
          };
          "language_servers" = [
            "nixd"
          ];
        };
        languages."Python" = {
          "tab_size" = 2;
          "formatter" = "language_server";
          "enable_language_server" = true;
          "format_on_save" = "on";
        };
        languages."Markdown" = {
          "format_on_save" = "on";
        };
        theme = lib.mkDefault {
          mode = "system";
          dark = "Catppuccin Mocha";
          light = "Catppuccin Mocha";
        };
        terminal = {
          shell = {
            program = "zsh";
          };
        };
        lsp = {
          "nixd" = {
            nixpkgs.expr = "import (builtins.getFlake \"/home/joey/Git/Jafner.net\").inputs.nixpkgs { } ";
            formatting.command = "nixfmt";
            options = {
              nixos.expr = "(builtins.getFlake \"/home/joey/Git/Jafner.net\").nixosConfigurations.desktop.options";
            };
          };
        };
        edit_predictions = {
          mode = "eager";
        };
        language_models = {
          "openai" = {
            version = "1";
            api_url = "https://openrouter.ai/api/v1";
            available_models = [
              {
                name = "deepseek/deepseek-r1-0528:free";
                display_name = "DeepSeek R1 (0528)";
                max_tokens = 163840;
                max_output_tokens = 16384;
              }
              {
                name = "deepseek/deepseek-chat-v3-0324:free";
                display_name = "DeepSeek V3";
                max_tokens = 163840;
                max_output_tokens = 16384;
              }
            ];
          };
          "ollama" = {
            "api_url" = "https://ollama.jafner.net";
            "available_models" = [
              {
                "name" = "deepseek-r1:8b";
                "display_name" = "DeepSeek R1 (8b)";
                "max_tokens" = 131072;
                "supports_tools" = false;
                "supports_thinking" = true;
                "supports_images" = false;
              }
              {
                "name" = "qwen3:8b";
                "display_name" = "Qwen3 (8b)";
                "max_tokens" = 40960;
                "supports_tools" = true;
                "supports_thinking" = true;
                "supports_images" = false;
              }
            ];
          };
        };
        assistant = {
          enabled = true;
          version = "2";
          default_model = {
            provider = "openai";
            model = "deepseek/deepseek-r1-0528:free";
          };
        };
        context_servers = {
          "filesystem" = {
            "command" = {
              "path" = "docker";
              "args" = [
                "run"
                "-i"
                "--rm"
                "-v"
                "/local-directory:/local-directory"
                "mcp/filesystem"
                "/local-directory"
              ];
              "env" = {};
            };
            "settings" = {};
          };
          "nixos" = {
            "command" = {
              "path" = "nix";
              "args" = [
                "run"
                "github:utensils/mcp-nixos"
                "--"
              ];
              "env" = {};
            };
            "settings" = {};
          };
        };
        agent = {
          version = "2";
          "inline_assistant_model" = {
            provider = "ollama";
            model = "deepseek-r1:8b";
          };
          "commit_message_model" = {
            provider = "ollama";
            model = "deepseek-r1:8b";
          };
          "thread_summary_model" = {
            provider = "ollama";
            model = "deepseek-r1:8b";
          };
        };
      };
    };
  };
}
