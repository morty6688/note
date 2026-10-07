先备份原 Terminal 配置，完成 Scoop 版安装和设置、验证能正常启动后，再卸载商店版。

1. 隐藏不需要的配置，像cmd等（设置 - 配置文件 - 从下拉菜单中隐藏，保存）

   - Terminal 会自动检测 PowerShell 7，不要再手动添加重复入口。若两个 PowerShell 指向同一安装，隐藏或删除其中一个配置即可，无需卸载软件。Windows PowerShell 5.1 是不同版本，保留用于维护更新。

1. 下载[MesloLGS NF 字体](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#fonts)：在该页面搜索MesloLGS NF 

   - 下载后需要手动打开四个字体文件，分别点击“安装”，然后重新打开 Terminal。本机仅复制文件并写入注册表后仍出现字体相关弹窗，需要手动点击安装。

1. 设置git bash为默认

     - 先打开Terminal，随便复制一个配置文件，保存

     - 然后将下面的配置复制过去，**覆盖除了guid的部分**，并将其移动到powershell前面（但是右键菜单顺序好像跟这个也没关系）
     
       ```
       // Git Bash亚克力半透明主题，font项为了支持powershell10k的字体
       {
         "guid": "这一行不要覆盖",
         "name": "bash",
         "icon": "C:\\Users\\morty\\scoop\\apps\\git\\current\\usr\\share\\git\\git-for-windows.ico",
         "commandline": "C:\\Users\\morty\\scoop\\apps\\git\\current\\bin\\bash.exe -i -l",
         "startingDirectory": "D:\\project\\self\\test",
         "font": 
         {
           "face": "MesloLGS NF",
           "size": 10.0
         },
         "opacity": 75,
         "closeOnExit": "graceful",
         "colorScheme": "Campbell",
         "cursorColor": "#FFFFFF",
         "cursorShape": "bar",
         "hidden": false,
         "historySize": 9001,
         "padding": "0, 0, 0, 0",
         "snapOnInput": true,
         "useAcrylic": true
       }
       ```
     
     - 然后把bash配置文件改成默认（设置 - 启动 - 默认配置文件），保存
     
     - 将窗口大小改成120*25（设置 - 启动 - 启动大小）。将bash和powershell的字体大小都设置为10（修改位置：具体配置文件 - 外观）。
     
     - 打开自动将所选内容复制到剪贴板（设置 - 交互）


2. 添加右键菜单（手动处理）
   - https://github.com/morty6688/windowsterminal-shell-scoop
   - 按仓库说明在管理员 PowerShell 7 中执行安装。本机和之前的系统均未通过 AI 自动安装成功；注册表检查通过不代表菜单实际可用，需手动处理并在资源管理器中验证。


3. （可选）wsl设置

   - 亚克力半透明

       ```json
       // WSL2
       {
         "source": "Windows.Terminal.Wsl",
         "startingDirectory": "\\\\wsl$\\Ubuntu\\home\\morty"
         // 后面的跟bash一样
       }
       ```

