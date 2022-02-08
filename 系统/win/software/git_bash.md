- win10安装zsh：

  https://gist.github.com/fworks/af4c896c9de47d827d4caa6fd7154b6b

  - 但是不要安装oh-my-zsh，安装powerlevel10k，并在bash.bashrc中设置zsh默认

  - 所有使用scoop对于Git的更新或修改操作全部需要切换到powershell执行，并在修改前结束bash.exe和zsh.exe进程。使用scoop cleanup清理旧版本时，需要备份[bash.bashrc](resources/bash.bashrc)文件到/etc目录，并重新安装[zsh](resources/zsh-5.8-5-x86_64.pkg.tar.zst)。

- 删除右键菜单，建议用win terminal

  - https://blog.csdn.net/yelllowcong/article/details/77663442

- bash.bashrc文件

  - 代名 

    ```bash
    alias python3=python
    ```

  - 历史记录 

    ```bash
    PROMPT_COMMAND='history -a'
    ```

  

  

