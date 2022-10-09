1. 配置文件（conf.user.json）：

   - win: 

     ```
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
         "源代码模式": "Ctrl+`",
         "打开文件夹": "Ctrl+Shift+O"
         // "删除...": "Delete"
       },
       "autoSaveTimer": 0.01, // Double, default is 5. The unit is "minute"
       "monocolorEmoji": false, //default false. Only work for Windows
       "maxFetchCountOnFileList": 500,
       "flags": [] // default [], append Chrome launch flags, e.g: [["disable-gpu"], ["host-rules", "MAP * 127.0.0.1"]]
     }
     ```

   - mac: 见[mac_setup](../mac/setup.md)


2. 通用设置项：开启自动保存；启动时重新打开上次的文件和目录
3. 图像设置项：复制图片到文件夹；优先相对路径
4. markdown设置项：代码块显示行号

5. 使用技巧
   - 中途取消列表：先向后缩进再取消，否则会取消整个列表
