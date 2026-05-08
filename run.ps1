$configFile = Join-Path $PSScriptRoot "services.json"
$services = Get-Content $configFile -Raw | ConvertFrom-Json

$colorMap = @{
    '0' = [ConsoleColor]::Black;      '1' = [ConsoleColor]::DarkBlue;
    '2' = [ConsoleColor]::DarkGreen;  '3' = [ConsoleColor]::DarkCyan;
    '4' = [ConsoleColor]::DarkRed;    '5' = [ConsoleColor]::DarkMagenta;
    '6' = [ConsoleColor]::DarkYellow; '7' = [ConsoleColor]::Gray;
    '8' = [ConsoleColor]::DarkGray;   '9' = [ConsoleColor]::Blue;
    'A' = [ConsoleColor]::Green;      'B' = [ConsoleColor]::Cyan;
    'C' = [ConsoleColor]::Red;        'D' = [ConsoleColor]::Magenta;
    'E' = [ConsoleColor]::Yellow;     'F' = [ConsoleColor]::White
}

function Find-Service($name) {
    return $services | Where-Object { $_.name -ieq $name }
}

function Set-ConsoleColor($colorCode) {
    $bg = $colorMap[$colorCode[0].ToString().ToUpper()]
    $fg = $colorMap[$colorCode[1].ToString().ToUpper()]
    $host.UI.RawUI.BackgroundColor = $bg
    $host.UI.RawUI.ForegroundColor = $fg
    Clear-Host
}

if ($args.Count -eq 0) {
    Write-Host "Usage: run [option1] [option2] ..."
    Write-Host ""
    Write-Host "Options:"
    foreach ($svc in $services) {
        Write-Host "  $($svc.name.PadRight(15)) - $($svc.command)"
    }
    exit 0
}

if ($args.Count -eq 1) {
    $svc = Find-Service $args[0]
    if (-not $svc) {
        Write-Host "Unknown option: $($args[0])"
        exit 1
    }
    Set-ConsoleColor $svc.color
    Write-Host "===== $($svc.name.ToUpper()) ====="
    Write-Host ""
    Set-Location $svc.path
    Invoke-Expression $svc.command
    exit 0
}

foreach ($name in $args) {
    $svc = Find-Service $name
    if (-not $svc) {
        Write-Host "Unknown option: $name"
        continue
    }
    $label = $svc.name.ToUpper()
    $cmdStr = "color $($svc.color) && echo ===== $label ===== && echo. && cd /d ""$($svc.path)"" && $($svc.command)"
    Start-Process cmd -ArgumentList "/k", $cmdStr
}
