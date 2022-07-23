- 添加右键菜单（**已经自带，不需要自己再次设置**）

  将以下ico文件放到C:\icons\terminal.ico目录，运行如下脚本，
  
  [Add open Windows terminal here into right-click context menu.bat](resources/win-terminal-here.bat)
  
  [terminal.ico](resources/terminal.ico)
  
- 设置git bash为默认
  - 先打开Terminal，添加新配置文件，选择Git Bash安装目录下的bin目录中的bash.exe。
  - 添加主题，然后选为默认

- bash主题

  - 亚克力半透明

    ```json
    // WSL2
    {
      "acrylicOpacity": 0.75,
      "closeOnExit": "graceful",
      "colorScheme": "Campbell",
      "cursorColor": "#FFFFFF",
      "cursorShape": "bar",
      "font": {
        "face": "Consolas",
        "size": 12
      },
      "hidden": false,
      "historySize": 9001,
      "padding": "0, 0, 0, 0",
      "snapOnInput": true,
      "useAcrylic": true,
      "guid": "{2c4de342-38b7-51cf-b940-2309a097f518}",
      "name": "Ubuntu",
      "source": "Windows.Terminal.Wsl",
      "startingDirectory": "\\\\wsl$\\Ubuntu\\home\\lijian"
    }
    ```

    ```json
    // Git Bash
    {
      "commandline": "C:\\Users\\lijian\\scoop\\apps\\git\\current\\bin\\bash.exe -i -l",
      "guid": "{399574cd-94a3-4fe2-bb49-4d6e2b3ec624}",
      "name": "Git Bash",
      "startingDirectory": "D:\\projs",
      "acrylicOpacity": 0.75,
      "closeOnExit": "graceful",
      "colorScheme": "Campbell",
      "cursorColor": "#FFFFFF",
      "cursorShape": "bar",
      "font": {
        "face": "Consolas",
        "size": 12
      },
      "hidden": false,
      "historySize": 9001,
      "padding": "0, 0, 0, 0",
      "snapOnInput": true,
      "useAcrylic": true
    }
    ```

    
