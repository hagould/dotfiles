function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    if($GitPromptSettings.DefaultForegroundColor) {
        $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor
    }

    Write-Host $pwd -nonewline -ForegroundColor ([ConsoleColor]::Yellow)

    # If we have dnvm, use it to determine the active KRE
    if(Get-Command dnvm -ErrorAction SilentlyContinue) {
        $activeDnx = dnvm list -passthru | where { $_.Active }
        if($activeDnx) {
            Write-Host " (" -nonewline -ForegroundColor ([ConsoleColor]::Yellow)
            Write-Host "dnx-$($activeDnx.Runtime)-win-$($activeDnx.Architecture).$($activeDnx.Version)" -nonewline -ForegroundColor ([ConsoleColor]::Cyan)
            Write-Host ")" -nonewline -ForegroundColor ([ConsoleColor]::Yellow)
        }
    }

    if(Get-Command Write-VcsStatus -ErrorAction SilentlyContinue) {
        Write-VcsStatus
    }

    Write-Host
    Write-Host "ps1 #" -nonewline -ForegroundColor ([ConsoleColor]::Green)

    $LASTEXITCODE = $realLASTEXITCODE
    $Host.UI.RawUI.WindowTitle = $pwd
    return " "
}
