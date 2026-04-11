## powershell

#### 1.0版本

- 可以右键开始菜单图标去打开
- 位置：`C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`
- 作用：有时还是需要用这个最古老的powershell去执行一些涉及到bash、新版powershell、zsh自身的命令。

#### alias

- 需要分别创建powershell 1.0和最新版powershell的配置文件，在两个powershell中分别运行以下命令，然后直接保存打开的文件即可：

  ```powershell
  code $PROFILE
  ```

- 然后修改该文件内容，改为如下所示：

  ```powershell
  # scoop
  New-Alias -Name s -Value scoop
  function sup {
      param (
          [Parameter(Mandatory = $false)]
          [string]$packageName,
          [Parameter(Mandatory = $false)]
          [switch]$all
      )
      if ($all) {
          scoop update *
      }
      else {
          scoop update $packageName
      }
  }
  function ss { (scoop update) ; (scoop status) }
  function scu {
      param (
          [Parameter(Mandatory=$false)]
          [string]$packageName,
          [Parameter(Mandatory=$false)]
          [switch]$all
      )
      if ($all) {
          scoop cleanup *
      } else {
          scoop cleanup $packageName
      }
  }
  function sli { scoop list }
  function sin { scoop install $args }
  function sui { scoop uninstall $args }
  function se { scoop search $args }
  
  # proxy
  $proxy = "http://127.0.0.1:1130"
  $env:HTTP_PROXY = $proxy
  $env:HTTPS_PROXY = $proxy
  ```

  - 注意`sli`和`sin`命令相比bash版本多了一个字母，不过一般也不会用这两个命令。powershell里主要用`sup`和`scu`。

- 其他命令：

  - 查看所有别名：

    ```powershell
    Get-Alias
    ```
