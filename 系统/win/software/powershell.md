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

#### Git Bash / zsh 快捷命令的 PowerShell 版本

在 Windows PowerShell 5.1 和 PowerShell 7 中分别执行 `code $PROFILE`，将以下内容追加到配置文件，保留上面的 Scoop 配置。保存后重新打开终端生效。

- 带参数的命令使用函数，`@args` 将调用参数传给对应命令。
- 保留所有 PowerShell 内置别名。冲突的快捷命令增加一个字母：`gin → gini`（git init）、`gc → gcl`（git clone）、`gp → gpl`（git pull）、`gu → gup`（git push）、`gm → gme`（git merge）、`gcm → gcmt`（git commit）、`ni → nin`（npm install -D）；原来的 npm init 使用 `nini`。
- Scoop 仍使用 `sli` / `sin`，保留内置 `sl` / `si`；新增 `sho` / `suh`。
- `nb` 使用 `npm run build`，`yui` 使用 `yarn remove`，修正 Bash 示例中的命令写法。
- `cz` 编辑 zsh 配置，`cprof` 编辑当前 PowerShell 配置。`proxy` / `noproxy` 只修改当前会话的代理环境变量。
- zsh 的 history、completion、bindkey 和 `ls --color=auto` 属于 shell 自身配置，不直接移植到 PowerShell。

```powershell
# BEGIN shell shortcuts
function g { git @args }
function gcl { git clone @args }
function gini { git init @args }
function ga { git add @args }
function gpl { git pull @args }
function gup { git push @args }
function gs { git status @args }
function gr { git rebase @args }
function gme { git merge @args }
function gcmt { git commit @args }
function sho { scoop hold @args }
function suh { scoop unhold @args }
function cz { code "$HOME/.zshrc" @args }
function nini { npm init @args }
function nin { npm install -D @args }
function n { npm @args }
function nl { npm list @args }
function na { npm add @args }
function nr { npm remove @args }
function ns { npm start @args }
function nb { npm run build @args }
function nu { npm update @args }
function pnin { pnpm init @args }
function pni { pnpm install @args }
function pn { pnpm @args }
function pnl { pnpm list @args }
function pna { pnpm add @args }
function pnr { pnpm remove @args }
function pns { pnpm start @args }
function pnb { pnpm build @args }
function pnu { pnpm update @args }
function y { yarn @args }
function ys { yarn start @args }
function yb { yarn build @args }
function yl { yarn list @args }
function yi { yarn install @args }
function yui { yarn remove @args }
function tp { telepresence @args }
function tpc { telepresence connect @args }
function tps { telepresence status @args }
function tpq { telepresence quit @args }
function tpv { telepresence version @args }
function pi { pip install @args }
function pl { pip list @args }
function gmt { go mod tidy @args }
function oc { opencode @args }
function mm { mimo @args }
function cdx { codex @args }
function cprof { code $PROFILE @args }
function proxy {
    $env:HTTP_PROXY = 'http://127.0.0.1:1130'
    $env:HTTPS_PROXY = $env:HTTP_PROXY
    $env:SOCKS5_PROXY = 'socks5://127.0.0.1:1130'
    Write-Output 'HTTP Proxy on'
}
function noproxy {
    'HTTP_PROXY', 'HTTPS_PROXY', 'SOCKS5_PROXY' | ForEach-Object {
        Remove-Item "Env:$_" -ErrorAction SilentlyContinue
    }
    Write-Output 'HTTP Proxy off'
}
# END shell shortcuts
```

#### Anaconda / Conda 快捷命令

先安装 Anaconda 并执行 `conda init powershell`，然后在 `$PROFILE` 中追加以下配置，重新打开终端。PowerShell 7 和 Windows PowerShell 5.1 的配置文件需要分别添加；执行策略须允许加载配置文件。

这些名称不覆盖 PowerShell 内置别名。与 Bash 示例保持一致，分别使用 `cr`（删除包）和 `crn`（指定环境名删除包）。例如 `cc demo python=3.12` 创建环境，`ca demo` 激活，`cda` 退出，`crn demo numpy` 删除环境中的包；`crn demo --all` 删除整个环境。`pi` / `pl` 沿用上面的 pip 快捷命令。

```powershell
# BEGIN conda shortcuts
function c { conda @args }
function ci { conda install @args }
function cu { conda update @args }
function cr { conda remove @args }
function cl { conda list @args }
function ca { conda activate @args }
function cda { conda deactivate @args }
function cc { conda create --name @args }
function crn { conda remove --name @args }
function cel { conda env list @args }
# END conda shortcuts
```
