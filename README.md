PowerShell Ping Script with Color-Coded Summary Report

This PowerShell script allows users to ping a specified IP address a defined number of times and then provides a color-coded summary report of the results. The script logs all ping attempts and their outcomes to a text file for later review.
Features

    User Input: Prompt users to enter the IP address and the number of ping attempts.
    Logging: Save ping results to a log file with timestamps.
    Summary Report: Display a formatted and color-coded summary report directly in the PowerShell console.
    Color Coding:
        Success Rate at 100%: Green
        Success Rate between 98% and 99.99%: Yellow
        Success Rate below 98%: Red

How to Use

    Run the Script: Execute the script in PowerShell.
    Enter Details: When prompted, enter the IP address to ping and the number of ping attempts.
    View Results: The script will perform the pings, log the results, and display a summary report with color-coded success rates.
    Close Prompt: Press any key to close the console window after viewing the report.

Script Details

    Write-Color Function: Changes the text color in the console for enhanced readability of the summary report.
    Format-BoxLine Function: Formats the summary report lines for a clean, boxed display.
    Logging Directory: Creates a "PingLogs" directory in the script's root path to store log files.
    Ping Logic: Uses Test-Connection to perform the pings and records success or failure for each attempt.
    Statistics Calculation: Computes total pings, successful pings, failed pings, success rate, and average response time.
