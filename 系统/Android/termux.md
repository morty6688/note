## termux

偶尔在手机上可能也需要使用一下终端，可以用termux

### 初始化

先运行termux-setup-storage，获取存储权限

#### git

1. ```
   pkg install git
   ```

2. 文件管理根目录（`/storage/emulated/0/`），所以：

   ```
   mkdir /storage/emulated/0/project
   ```

   - 也可以直接放到Documents下面（如果documentsui有闪退bug，只能采取折中办法：把项目目录都放到Documents下面）

3. ```
   git config --global http.proxy socks5://127.0.0.1:1130
   git config --global https.proxy socks5://127.0.0.1:1130
   ```

   ```
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
   
   - 如果是tun模式，改用：
   
     ```
     mkdir -p ~/.ssh
     
     cat >> ~/.ssh/config <<'EOF'
     Host github.com
         HostName ssh.github.com
         Port 443
         User git
     EOF
     
     chmod 600 ~/.ssh/config
     ```
   
4. ```
   ssh -T git@github.com
   ```
   
5. ```
   cat /data/data/com.termux/files/home/.ssh/id_ed25519.pub
   ```

   公钥导入github，然后就可以clone了


#### zsh

- ```
  pkg install zsh
  ```

- 设置为默认

  ```
  chsh -s zsh
  ```

- powerlevel10k：

  ```
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
  ```

- 修改.zshrc（`nano ~/.zshrc`）

  ```
  cat >> ~/.zshrc <<'EOF'
  
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
  
  # 起始目录
  cd /storage/emulated/0/Documents/project
  
  EOF
  
  source ~/.zshrc
  ```

- （偶发）禁用gitstatus，`nano ~/.p10k.zsh`，然后输入下面行（gitstatus有bug，无法初始化）

  ```
  typeset -g POWERLEVEL9K_DISABLE_GITSTATUS=true
  ```

  