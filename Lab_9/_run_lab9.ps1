$ErrorActionPreference = 'Continue'
$log = 'C:\Programing\University\PMD\Lab_9\_run_lab9.log'
$adb = 'C:\Users\Andrii\AppData\Local\Android\Sdk\platform-tools\adb.exe'
function Log($m) { "$(Get-Date -Format HH:mm:ss) $m" | Add-Content -Path $log }
Set-Content -Path $log -Value "RUN-START $(Get-Date -Format o)" -Encoding utf8

# 1. Kill any stale emulator
Get-Process emulator -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process qemu-system-x86_64 -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

# 2. Launch emulator (visible window)
$p = Start-Process -FilePath 'C:\Users\Andrii\AppData\Local\Android\Sdk\emulator\emulator.exe' -ArgumentList '-avd','lab20','-no-audio' -PassThru
Log "EMU-STARTED pid=$($p.Id)"

# 3. Wait for device (up to 240s)
$ok = $false
for ($i = 0; $i -lt 48; $i++) {
  Start-Sleep -Seconds 5
  $p.Refresh()
  if ($p.HasExited) { Log "EMU-DIED exit=$($p.ExitCode) at +$($i*5)s"; exit 1 }
  $out = & $adb devices 2>&1 | Out-String
  if ($out -match 'emulator-5554\s+device') { $ok = $true; Log "DEVICE-ONLINE at +$($i*5)s"; break }
}
if (-not $ok) { Log "NO-DEVICE after 240s"; exit 1 }

# 4. Wait for boot completed (up to 180s)
$boot = $false
for ($i = 0; $i -lt 36; $i++) {
  $b = (& $adb -s emulator-5554 shell getprop sys.boot_completed 2>&1 | Out-String).Trim()
  if ($b -eq '1') { $boot = $true; Log "BOOT-COMPLETED"; break }
  Start-Sleep -Seconds 5
}
if (-not $boot) { Log "NO-BOOT after 180s"; exit 1 }

# 5. Unlock screen
& $adb -s emulator-5554 shell input keyevent 82 | Out-Null
Start-Sleep -Seconds 1
& $adb -s emulator-5554 shell input swipe 540 1900 540 800 250 | Out-Null
Start-Sleep -Seconds 2

# 6. Launch Lab 9 app
& $adb -s emulator-5554 shell monkey -p com.example.profile_app -c android.intent.category.LAUNCHER 1 | Out-String | Log "MONKEY:"
Start-Sleep -Seconds 6

# 7. Screenshot
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $adb
$psi.Arguments = '-s emulator-5554 exec-out screencap -p'
$psi.RedirectStandardOutput = $true
$psi.UseShellExecute = $false
$cp = [System.Diagnostics.Process]::Start($psi)
$fs = [System.IO.File]::OpenWrite('C:\Programing\University\PMD\Lab_9\shots\l9_now.png')
$cp.StandardOutput.BaseStream.CopyTo($fs)
$fs.Close(); $cp.WaitForExit(10000)
Log "SHOT-SAVED"

# 8. Window visibility check
$w = (Get-Process emulator -ErrorAction SilentlyContinue | Select-Object -First 1).MainWindowTitle
Log "WINDOW-TITLE=[$w]"
Log "RUN-END"
Write-Output "DONE"
