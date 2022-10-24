## 新mac设置

### 系统


- sys perf

  - Accessibility

    - Pointer Control - Trackpad Options - Enable dragging - 3 finger drag(三指拖移)

  - Trackpad

    - Point & Click - Tap to click(勾选轻触点击)
    - Scroll & Zoom - 取消勾选Scroll direction: Natural（跟scroll-reverser配合用）
    - More Gestures - swipe between pages(取消勾选)

  - Keyboard

    - Text

      - 取消勾选Correct spelling automatically

    - Shortcuts

      - Input Sources: select the previous input source快捷键改为option+space

      - Mission Control: Show Desktop(取消勾选f11显示桌面)

      - App Shortcuts:

        - typora:

        ```
        Code Fences: shift+cmd+k
        Ordered List: cmd+/
        Unordered List: cmd+.
        Source Code Mode: cmd+~
        ```

      - Function Keys: 添加vscode，chrome，idea

    - Input Sources：删除多余的输入法，只保留搜狗输入法

  - Dock & Menu Bar: 设置位置在右边并调整大小

  - Mission Control - Hot Corners: 右上角设置为桌面，双屏使用需对齐右侧边界

- 其他设置

  - trash添加data added一列表示删除日期

## 软件安装与设置

- 以下为不建议使用brew的软件：

  - 搜狗输入法

  - Logitech options+

  - idea

- app store里安装的软件：

  - iRightMouse（付费。。。说实话功能有点少）

  - Text Scanner（ocr)

  - MyZip，右键菜单压缩和解压（感觉还是有些bug，没办法mac上bandizip收费）

- 使用brew安装的软件：

  - ```
    brew install --cask 1password
    ```

  - ```
    brew install --cask scroll-reverser
    ```

    - Scrolling Axes：勾选Reverse Vertical和Reverse Horizontal
    - Scrolling Devices：勾选Reverse Trackpad

  - ```
    brew install --cask typora
    ```

  - ```
    brew install --cask clipy
    ```

    - 多重剪贴板，可以导入导出

  - ```
    brew install --cask macgesture
    ```

    - 鼠标手势(触摸板也可以识别)，下为导入导出语句

      ```
      defaults import com.codefalling.MacGesture backup.list
      defaults export com.codefalling.MacGesture backup.plist
      ```

    - 手势示例：[backup](resources/backup.plist)

  - ```
    brew install deepl
    ```


  - ```
    brew install --cask xnviewmp
    ```

    - Tools > Settings > General -- General tab -- Mode when starting with a file -- Normal.



  - ```
    brew install --cask rectangle
    ```
    
    - move to last/next monitor: ctrl+option+left/right
    


  - ```
    brew install --cask hiddenbar
    ```
    
    - sudo xattr -r -d com.apple.quarantine /Applications/Hidden\ Bar.app



  - ```
    brew install java11
    ```
    
    - sudo ln -sfn /usr/local/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk



  - ```
    brew install git
    ```
    


  - ```
    brew install libpq
    ```

    - 用于pg_dump，位置在/usr/local/opt/libpq/bin下面


  - ```
    brew install --cask iterm2
    ```

    - Mac自带zsh，安装powerlevel10k

    - Font size: 15，window: 100*25，光标：竖线



  - ```
    brew install --cask docker
    ```

    - Enable k8s



  - ```
    brew install --cask visual-studio-code
    ```

    - 开启同步



  - ```
    brew install --cask redisinsight
    ```



  - ```
    brew install wget
    ```



- 暂时未用

  - brew install --cask popclip

  - brew install --cask bettertouchtool



## 常用命令

- 终止程序

  ```
  sudo lsof -i :8080
  kill -9 <PID>
  ```

  



​	