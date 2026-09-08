# 🛠️ Dotfiles (`~/.config`)

Centralized, portable configuration for macOS development, terminal customization, and agentic coding workflows.

---

## 🚀 Quick Start on a New Mac (Zero-Friction Setup)

Run these two commands on any new computer:

```bash
# 1. Clone this repository to ~/.config
git clone git@github.com:dannyhamam/.config.git ~/.config

# 2. Run the bootstrap script
~/.config/bootstrap.sh
```

### What Happens Automatically:
1. **`~/.zshrc` is symlinked** to `~/.config/zsh/.zshrc`.
2. **iTerm2 Tokyo Night Dynamic Profile** is linked into `~/Library/Application Support/iTerm2/DynamicProfiles/`.
3. **iTerm2 split-pane optimizations** (35% inactive dimming and pane title headers) are configured in macOS defaults.
4. On your first terminal launch, **Oh My Zsh is automatically installed** in the background if it is missing.

---

## 📂 Repository Structure

```
~/.config/
├── .gitignore                     # Ignores runtime files and local overrides
├── README.md                      # Setup guide and reference manual
├── bootstrap.sh                   # One-shot idempotent setup script
├── iterm2/
│   └── DynamicProfiles/
│       └── main.json              # Tokyo Night 'main' profile, 13pt font, 1.15 line height, unlimited scrollback
├── zsh/
│   └── .zshrc                     # Shared Zsh config, paths, tools, and local override loader
├── nvim/                          # Neovim configuration (Tokyo Night theme, LSP, Treesitter)
└── aerospace/                     # AeroSpace tiling window manager configuration
```

---

## 🔒 Machine-Specific & Work Isolation (`~/.zshrc.local`)

To keep work-specific functions, company internal scripts, and secret credentials off GitHub while using the same shared `.config` repository across personal and work laptops:

1. Create a file at `~/.zshrc.local` (lives in `$HOME/`, completely outside of Git).
2. Place any work-specific functions (e.g. `tilt_search()`, `gardev()`), proprietary paths, and credentials inside `~/.zshrc.local`.
3. `~/.config/zsh/.zshrc` automatically checks for and sources `~/.zshrc.local` on startup.
4. If `~/.zshrc.local` does **not** exist (such as on a clean personal laptop), your shell will display:
   ```
   ℹ️  No ~/.zshrc.local found (running shared configs only).
   ```

---

## ⚡ Agentic Coding & Split-Pane Shortcuts (iTerm2)

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `Cmd + Shift + Enter` | **Zoom / Maximize Split Pane** | Temporarily expands the active split pane to full window (great for reading wide diffs). Press again to restore. |
| `Cmd + Shift + Up / Down` | **Jump between Prompts** | Uses iTerm2 shell integration marks to jump directly to previous/next conversation turns without manual scrolling. |
| `Cmd + Option + A` | **Alert on Next Mark** | Triggers a macOS system notification when a long-running agent command or test finishes. |
| `Cmd + [` / `Cmd + ]` | **Navigate Split Panes** | Cycles focus between adjacent split panes. |
| `Cmd + D` | **Split Vertically** | Opens a new split pane to the right. |
| `Cmd + Shift + D` | **Split Horizontally** | Opens a new split pane below. |
