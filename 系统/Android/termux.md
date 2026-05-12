## termux

偶尔在手机上可能也需要使用一下终端，可以用termux

### 初始化

先运行termux-setup-storage，获取存储权限

#### git

1. ```
   pkg install git
   ```

2. 文件管理根目录

   ```
   cd /storage/emulated/0/
   ```

   - 可以在根目录下创建新目录

3. ```
   git config --global http.proxy socks5://127.0.0.1:19802
   git config --global https.proxy socks5://127.0.0.1:19802
   ```

4. ```
   ssh-keygen -t ed25519 -C 
   ssh -T git@github.com
   ```

5. ```
   cat /data/data/com.termux/files/home/.ssh/id_ed25519.pub
   ```

   公钥导入github，然后就可以clone了

#### 起始目录

- ```
  nano /data/data/com.termux/files/usr/etc/bash.bashrc
  ```

- 然后在打开的文件最后一行添加：

  ```
  cd /storage/emulated/0/Documents/proj
  ```

  - 由于obsidian文件权限有bug，所以只能采取折中办法：把项目目录都放到Documents下面

#### zsh

- ```
  pkg install zsh
  ```

- 设置为默认

  ```
  chsh -s zsh
  ```

- powerlevel10k：还是那两条命令安装

- 修改.zshrc（`nano ~/.zshrc`）

  ```
  # git alias
  alias g='git'
  alias gc='git clone'
  alias gin='git init'
  alias ga='git add'
  alias gp='git pull'
  alias gu='git push'
  alias gs='git status'
  alias gr='git rebase'
  alias gm='git merge'
  alias gcm='git commit'
  
  # history
  HISTFILE=~/.zsh_history
  HISTSIZE=10000
  SAVEHIST=1000
  setopt SHARE_HISTORY
  
  # show color
  alias ls='ls --color=auto'
  
  # .zhsrc
  alias nz='nano ~/.zshrc'
  ```

- 禁用gitstatus，`nano ~/.p10k.zsh`，然后输入下面行（gitstatus有bug，无法初始化）

  ```
  typeset -g POWERLEVEL9K_DISABLE_GITSTATUS=true
  ```

  