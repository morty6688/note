### 偏好设置

1. 文件：开启自动保存；启动时重新打开上次的文件和目录

2. 图像：复制图片到文件夹（对网络位置）；优先相对路径；

3. markdown：代码块显示行号；扩展语法全部勾选

4. 通用：右键菜单加入：新建markdown（第一行是加入，第二行是删除），需要重启

5. 配置文件（conf.user.json）：

   - win: 

     ```json
     /** For advanced users. */
     {
       "defaultFontFamily": {
         "standard": null, //String - Defaults to "Times New Roman".
         "serif": null, // String - Defaults to "Times New Roman".
         "sansSerif": null, // String - Defaults to "Arial".
         "monospace": null // String - Defaults to "Courier New".
       },
       "autoHideMenuBar": false, //Boolean - Auto hide the menu bar unless the `Alt` key is pressed. Default is false.
     
       // Array - Search Service user can access from context menu after a range of text is selected. Each item is formatted as [caption, url]
       "searchService": [["Search with Google", "https://google.com/search?q=%s"]],
     
       // Custom key binding, which will override the default ones.
       // see https://support.typora.io/Shortcut-Keys/#windows--linux for detail
       "keyBinding": {
         // for example:
         // "Always on Top": "Ctrl+Shift+P"
         // All other options are the menu items 'text label' displayed from each typora menu
         "有序列表": "Ctrl+/",
         "无序列表": "Ctrl+.",
         "源代码模式": "Ctrl+g",
         "打开文件夹": "Ctrl+Shift+O",
         "删除线": "alt+shift+d",
         "内联公式": "ctrl+q",
         "代码": "ctrl+`",
         // "删除...": "Delete"
       },
       // "autoSaveTimer": 0.01, // Double, default is 5. The unit is "minute"
       "monocolorEmoji": false, //default false. Only work for Windows
       "maxFetchCountOnFileList": 500,
       "flags": [] // default [], append Chrome launch flags, e.g: [["disable-gpu"], ["host-rules", "MAP * 127.0.0.1"]]
     }
     ```
   
   - mac: 见[mac_setup](../mac/setup.md)


### 插件

- 安装[typora_plugin](https://github.com/obgnail/typora_plugin)，按照步骤替换文件

  - 安装：用everything搜window.html，打开所在目录把解压出来的plugin复制进去，然后进入/plugin/bin目录运行ps脚本
  
  - 把自动编号功能关掉
  
  - 标签页管理 - 快捷键 - 去掉==ctrl+`==用于切换标签页的快捷键
  
  - 悬浮动作按钮：距右边框改为20px
  
  - 需要开启的插件：
    - 光标历史
  

### 其他配置

- 将以下行添加到path环境变量：

  ```
  C:\Program Files\Typora
  ```

#### 使用技巧

- 中途取消列表：先向后缩进再取消，否则会取消整个列表
- 在数字编号后面回车，可以在上一行增加编号
- 在当前行文本后直接按`ctrl+shift+k`，可以直接在下一行添加一个代码块

