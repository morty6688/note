### 配置

#### 基本配置

1. config命令

```bash
git config --list

git config --global user.name lijian12345
git config --global user.email 

git config --local user.name lijian12345
git config --local user.email 
# 使用vscode作为默认编辑器
git config --global core.editor "code --wait"
```

2. 代理

```bash
git config --global http.proxy 127.0.0.1:1130
git config --global https.proxy http://127.0.0.1:1130
```

3. 配置ssh-key，将生成的.pub公钥添加到目标仓库

```
ssh-keygen -t ed25519 -C "your_email@example.com"
```

4. 命令行显示中文

```
git config --global core.quotepath false
```

#### 进阶配置

- win安装zsh：

  https://gist.github.com/fworks/af4c896c9de47d827d4caa6fd7154b6b

  - 安装powerlevel10k，在用户目录下创建[.bashrc](resources/.bashrc)文件，并设置zsh默认（目前的版本创建完这个文件之后，第一次启动会报错并生成一个.bash_profile，再次启动就一切正常
  - **更新时注意事项**：所有使用scoop对于Git的更新或修改操作全部需要切换到powershell执行，并在修改前结束bash.exe和zsh.exe进程。使用scu命令清理旧版本时，需要重新安装[zsh](https://packages.msys2.org/package/zsh?repo=msys&variant=x86_64)，即解压zsh到Git目录。
  
- 双账号配置，在自己的主账号配置好之后，执行以下操作：

  - `ssh-keygen -t ed25519 -C "your_sub_email@sub.com"`，当出现提示时输入正确的路径，如`Enter file in which to save the key (/Users/you/.ssh/id_ed25519): /c/Users/username/.ssh/sub_ed25519`，注意路径要输全路径，不能输入`~/.ssh/sub_ed25519`，有时候识别不出来，然后把生成的公钥传到副账号github中

  - `code ~/.ssh/config`，输入如下内容：

    ```
    Host github.com
      User 主账号的用户名
      AddKeysToAgent yes
      IgnoreUnknown UseKeychain
      IdentityFile ~/.ssh/id_ed25519
    
    Host sub.com
      HostName github.com
      User 副账号的用户名
      AddKeysToAgent yes
      IgnoreUnknown UseKeychain
      IdentityFile ~/.ssh/sub_ed25519
    ```

  - 克隆副账号项目时用`git clone git@sub.com:副账号/项目名.git`

  - 副账号项目设置：`git config --local user.email your_sub_email@sub.com`


#### zsh配置

- ~/.zshrc

  ```
  # git alias
  alias g='git'
  alias gc='git clone'
  alias gi='git init'
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
  
  # completion
  autoload -Uz compinit && compinit
  autoload -Uz bashcompinit && bashcompinit
  ```

- ubuntu配置

  - powerlevel10k

    ```
    sudo apt install zsh
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/tools/theme/powerlevel10k
    echo 'source ~/tools/theme/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
    zsh
    ```

  - ubuntu设置为默认

    ```
    cat /etc/shells
    chsh -s /bin/zsh
    ```


#### 其他用法

- 强制忽略和取消忽略某些文件

  ```
  git update-index --assume-unchanged ***
  git update-index --no-assume-unchanged ***
  ```

- 远程仓库关联

  ```
  # 删除关联
  git remote remove origin
  # 添加关联
  git remote add origin git@github.com:git_username/repository_name.git
  ```

- gr修改历史

  - 用vscode打开项目（是为了用vscode实现的一个git rebase的UI），运行`gr -i --root` ，表示修改全部提交；或者`gr -i head~3`，表示修改最近的3个提交
  - 针对每个提交可以进行edit，drop等等操作，edit时使用`git commit --amend`修改，修改完毕后需要返回idea解决冲突，之后用`git rebase --continue`完成rebase操作
  - 使用`gu -f`强制push可以覆盖掉remote仓库的历史

### 问题

1. git版本为2.27.0以上时，使用git pull命令出现以下的警告：

   ```
   fatal: Need to specify how to reconcile divergent branches.
   ```

   https://blog.csdn.net/yao940622/article/details/120729218?utm_medium=distribute.pc_relevant.none-task-blog-2~default~baidujs_title~default-0.highlightwordscore&spm=1001.2101.3001.4242.1

   简单解决办法：

   ```
   git config --global pull.rebase false
   ```

2. OpenSSH_8.8p1在使用git clone时会出现如下问题：

   ```
   Unable to negotiate with x.x.x.x port 2222: no matching host key type found. Their offer: ssh-rsa
   ```

   解决办法：

   ```
   code ~/.ssh/config
   ```

   然后添加：

   ```
   Host *
     ServerAliveInterval 10
     HostKeyAlgorithms +ssh-rsa
     PubkeyAcceptedKeyTypes +ssh-rsa
   ```

3. schannel: next InitializeSecurityContext failed

   解决办法：

   ```
   git config --system http.sslbackend openssl
   ```

4. ssh: connect to host github.com port 22: Connection timed out：

   不知道为什么会出现这个。但是解决办法是在`~/.ssh/config`的每个配置中添加如下两行：

   ```
   Host github.com
     HostName ssh.github.com
     Port 443
   ```
