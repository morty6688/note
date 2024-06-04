1. 设置git bash为默认

     - 先打开Terminal，随便复制一个配置文件，命名为bash

     - 然后将下面的配置复制过去，覆盖除了guid和name的部分
     
       ```
       // Git Bash亚克力半透明主题，font项为了支持powershell10k的字体
       {
         "commandline": "C:\\Users\\morty\\scoop\\apps\\git\\current\\bin\\bash.exe -i -l",
         "startingDirectory": "~",
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
     
     - 然后把bash配置文件改成默认
     
     - 将窗口大小改成100*25。如果距离屏幕较近，建议将字号设置为10
     
     - 把cmd这种没什么用的配置文件隐藏掉
     
     - 打开自动将所选内容复制到剪贴板


2. 添加右键菜单
   -  https://github.com/morty6688/windowsterminal-shell-scoop


3. wsl设置

   - 亚克力半透明

       ```json
       // WSL2
       {
         "source": "Windows.Terminal.Wsl",
         "startingDirectory": "\\\\wsl$\\Ubuntu\\home\\morty"
         // 后面的跟bash一样
       }
       ```


4. bash临时代理（待测试）

   - ```
     export http_proxy='http://127.0.0.1:1130'    
     export https_proxy='http://127.0.0.1:1130'
     export telnet_proxy='http://127.0.0.1:1130'
     ```

     
