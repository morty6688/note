### 配置

#### 前置配置

- win10安装zsh：

  https://gist.github.com/fworks/af4c896c9de47d827d4caa6fd7154b6b

  - 安装powerlevel10k，并在bash.bashrc中设置zsh默认

  - 所有使用scoop对于Git的更新或修改操作全部需要切换到powershell执行，并在修改前结束bash.exe和zsh.exe进程。使用scoop cleanup清理旧版本时，需要备份[bash.bashrc](resources/bash.bashrc)文件到/etc目录，并重新安装[zsh](https://packages.msys2.org/package/zsh?repo=msys&variant=x86_64)，即解压zsh到Git目录。

  - .zshrc中设置别名

    ```
    alias g='git'
    alias gc='git clone'
    alias gp='git pull'
    ```

- 删除右键菜单，建议用win terminal

  - https://blog.csdn.net/yelllowcong/article/details/77663442

- bash.bashrc文件

  - 别名

    ```bash
    alias python3=python
    ```

  - 历史记录 

    ```bash
    PROMPT_COMMAND='history -a'
    ```

- 双账号配置：https://zhuanlan.zhihu.com/p/423007454

#### git配置

1. config命令

```bash
git config --list

git config --global user.name lijian12345
git config --global user.email 
git config --global --unset user.name
git config --global --unset user.email

git config --local user.name lijian12345
git config --local user.email 
git config --local --unset user.name
git config --local --unset user.email
# 使用vscode作为默认编辑器
git config --global core.editor "code --wait"
```

2. 代理

```bash
git config --global http.proxy 127.0.0.1:1130
```

3. 配置ssh-key，将生成的.pub公钥添加到目标仓库

```
ssh-keygen -t ed25519 -C ""
```

4. 命令行显示中文

```
git config --global core.quotepath false
```

5. 强制忽略和取消忽略某些文件

```bash
git update-index --assume-unchanged ***
git update-index --no-assume-unchanged ***
```
#### zsh配置

- 历史记录（.zshrc）

```bash
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt SHARE_HISTORY
```

- 文件夹显示颜色

```
alias ls='ls --color=auto'
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

- git alias

```
alias g='git'
alias gc='git clone'
```




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

   
