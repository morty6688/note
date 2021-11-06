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

- ubuntu设置为默认

```bash
cat /etc/shells
chsh -s /bin/zsh
```

- win10中的git bash安装zsh：

  https://gist.github.com/fworks/af4c896c9de47d827d4caa6fd7154b6b

  但是不要安装oh-my-zsh，安装powerlevel10k，并在bash.bashrc中设置zsh默认

- 
