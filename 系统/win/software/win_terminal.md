1. 隐藏不需要的配置，像cmd等（设置 - 配置文件 - 从下拉菜单中隐藏，保存）

1. 下载[MesloLGS NF 字体](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#fonts)：在该页面搜索MesloLGS NF 

1. 设置git bash为默认

     - 先打开Terminal，随便复制一个配置文件，保存

     - 然后将下面的配置复制过去，**覆盖除了guid的部分**
     
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
           "size": 12.0
         },
         "acrylicOpacity": 0.75,
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
     
     - 将窗口大小改成100*25（设置 - 启动 - 启动大小）。如果距离屏幕较近，建议将字号设置为10（修改位置：具体配置文件 - 外观，建议把bash和powershell都改了）
     
     - 打开自动将所选内容复制到剪贴板（设置 - 交互）


2. 添加右键菜单
   -  https://github.com/morty6688/windowsterminal-shell-scoop


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

