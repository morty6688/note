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

