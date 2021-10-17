- 历史记录（.zshrc）

```bash
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt SHARE_HISTORY
```

- powerlevel10k

```bash
sudo apt install zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/tools/theme/powerlevel10k
echo 'source ~/tools/theme/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
zsh
```

- 设置为默认

```bash
cat /etc/shells
chsh -s /bin/zsh
```

