# Define the function to get colored text output
function Write-Color {
    param (
        [string]$Text,
        [ConsoleColor]$Color
    )
    $OriginalColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $Color
    Write-Host $Text
    $Host.UI.RawUI.ForegroundColor = $OriginalColor
}

# Function to pad and format text for the box
function Format-BoxLine {
    param (
        [string]$Label,
        [string]$Value
    )
    $paddedText = "{0}: {1}" -f $Label, $Value
    return "║ " + $paddedText.PadRight(38) + " ║"
}

# Prompt user for IP address and number of pings
$ipAddress = Read-Host "Enter the IP address to ping"
$pingCount = [int](Read-Host "Enter the number of times to ping the IP address")

# Define log file path
$logDir = "$PSScriptRoot\PingLogs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir | Out-Null
}
$logFile = "$logDir\PingLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

# Initialize counters
$totalPings = 0
$successfulPings = 0
$failedPings = 0
$responseTimes = @()

# Ping the IP address
for ($i = 1; $i -le $pingCount; $i++) {
    $totalPings++
    $pingResult = Test-Connection -ComputerName $ipAddress -Count 1 -ErrorAction SilentlyContinue
    if ($pingResult) {
        $successfulPings++
        $responseTimes += [double]$pingResult.ResponseTime
        "$($pingResult.Address) responded in $($pingResult.ResponseTime) ms" | Tee-Object -FilePath $logFile -Append
    } else {
        $failedPings++
        "Request timed out." | Tee-Object -FilePath $logFile -Append
    }
}

# Calculate summary statistics
$successRate = [math]::Round(($successfulPings / $totalPings) * 100, 2)
$averageResponseTime = if ($responseTimes.Count -gt 0) { [math]::Round(($responseTimes | Measure-Object -Average).Average, 2) } else { 0 }

# Display summary
"Total Pings: $totalPings" | Tee-Object -FilePath $logFile -Append
"Successful Pings: $successfulPings" | Tee-Object -FilePath $logFile -Append
"Failed Pings: $failedPings" | Tee-Object -FilePath $logFile -Append
"Success Rate: $successRate%" | Tee-Object -FilePath $logFile -Append
"Average Response Time: $averageResponseTime ms" | Tee-Object -FilePath $logFile -Append

# Color-coded output
Write-Host "Summary Report:"
Write-Color "╔════════════════════════════════════════╗" Cyan
Write-Color "║            Summary Report              ║" Cyan
Write-Color "╟────────────────────────────────────────╢" Cyan
Write-Color (Format-BoxLine "Total Pings" $totalPings) Cyan
Write-Color (Format-BoxLine "Successful Pings" $successfulPings) Cyan
Write-Color (Format-BoxLine "Failed Pings" $failedPings) Cyan
if ($successRate -eq 100) {
    Write-Color (Format-BoxLine "Success Rate" "$successRate%") Green
} elseif ($successRate -ge 98) {
    Write-Color (Format-BoxLine "Success Rate" "$successRate%") Yellow
} else {
    Write-Color (Format-BoxLine "Success Rate" "$successRate%") Red
}
Write-Color (Format-BoxLine "Average Response Time" "$averageResponseTime ms") Cyan
Write-Color "╚════════════════════════════════════════╝" Cyan

# Prompt to close
Write-Host "`nPress any key to close this window..."
$x = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
