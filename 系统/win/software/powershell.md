## powershell

#### alias

- 需要分别创建系统自带的powershell和自己安装的powershell的配置文件，在两个powershell中分别运行以下命令，然后直接保存打开的文件即可：

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
  ```

  - 注意`sli`和`sin`命令相比bash版本多了一个字母

- 其他命令：

  - 查看所有别名：

    ```powershell
    Get-Alias
    ```

    