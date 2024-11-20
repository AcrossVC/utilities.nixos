# /etc/nixos/modules/home/vscode.nix
{ config, lib, pkgs, ... }:

{
  # Good practice to make the module configurable
  options.modules.vscode = {
    enable = lib.mkEnableOption "VSCode configuration";
  };

  config = lib.mkIf config.modules.vscode.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.unstable.vscode;

      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = with pkgs.unstable.vscode-extensions; [
        # Nix support
        jnoortheen.nix-ide  # Comprehensive Nix IDE features
        # bbenoist.nix  # Basic Nix syntax (alternative to nix-ide)
        
        # Writing and Documentation
        asciidoctor.asciidoctor-vscode  # AsciiDoc support
        # foam.foam-vscode  # Personal knowledge management
        # dendron.dendron   # Another PKM option
        # yzhang.markdown-all-in-one  # Enhanced Markdown support
        
        # Git Integration
        eamodio.gitlens    # Enhanced Git capabilities
        # mhutchie.git-graph  # Git history visualization
        
        # General Development
        ms-vscode.remote-ssh    # Remote development
        # ms-vscode-remote.remote-ssh-edit  # Remote SSH configuration editor
        
        # Terminal enhancements
        # tyriar.terminal-tabs  # Better terminal management
        
        # Theme and UI (uncomment your preferred theme)
        # zhuangtongfa.material-theme  # One Dark Pro
        # dracula-theme.theme-dracula  # Dracula
        # pkief.material-icon-theme    # Material Icon Theme
      ];

      userSettings = {
        # Editor settings
        "editor.fontSize" = 14;
        "editor.fontFamily" = "'FiraCode Nerd Font', 'Droid Sans Mono', 'monospace'";
        "editor.renderWhitespace" = "boundary";
        "editor.rulers" = [ 80 120 ];
        "editor.wordWrap" = "on";
        "editor.minimap.enabled" = true;
        
        # Workbench settings
        "workbench.startupEditor" = "none";
        "workbench.editor.enablePreview" = false;
        
        # Files settings
        "files.autoSave" = "onFocusChange";
        "files.trimTrailingWhitespace" = true;
        
        # Terminal settings
        "terminal.integrated.fontSize" = 14;
        "terminal.integrated.enableMultiLinePasteWarning" = false;
        
        # Git settings
        "git.enableSmartCommit" = true;
        "git.confirmSync" = false;
        "git.autofetch" = true;
        
        # Nix settings
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "[nix]" = {
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
        };
        
        # AsciiDoc settings
        "asciidoc.preview.useEditorStyle" = true;
        "asciidoc.preview.refreshInterval" = 500;
        
        # Markdown settings
        "[markdown]" = {
          "editor.wordWrap" = "on";
          "editor.quickSuggestions" = {
            "comments" = "on";
            "strings" = "on";
            "other" = "on";
          };
        };
        
        # Search settings
        "search.useGlobalIgnoreFiles" = true;
        "search.exclude" = {
          "**/.direnv" = true;
          "**/.git" = true;
          "**/node_modules" = true;
          "**/*.lock" = true;
        };
      };
    };
  };
}