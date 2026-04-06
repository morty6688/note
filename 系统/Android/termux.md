## termux

偶尔在手机上可能也需要使用一下终端，可以用termux

### 初始化

先运行termux-setup-storage，获取存储权限

#### git

1. ```bash
   cd /storage/emulated/0/
   mkdir termux-dir
   cd termux-dir
   ```

2. ```
   git config --global http.proxy socks5://127.0.0.1:19802
   git config --global https.proxy socks5://127.0.0.1:19802
   ```

3. ```
   ssh-keygen -t ed25519 -C 
   ssh -T git@github.com
   ```

4. ```
   cat /data/data/com.termux/files/home/.ssh/id_ed25519.pub
   ```

   公钥导入github，然后就可以clone了