### 配置

#### 1. git配置

1. config命令

```bash
git config --global user.name lijian12345
git config --global user.email 
git config --list
git config --global --unset user.name
git config --global --unset user.email
```

2. 代理

```bash
git config --global http.https://github.com.proxy socks5://127.0.0.1:10808
git config --global https.https://github.com.proxy socks5://127.0.0.1:10808
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
#### 2. zsh配置

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

   
