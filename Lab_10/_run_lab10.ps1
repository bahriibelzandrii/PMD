$ErrorActionPreference = 'Continue'
$log = 'C:\Programing\University\PMD\Lab_10\_run_lab10.log'
$adb = 'C:\Users\Andrii\AppData\Local\Android\Sdk\platform-tools\adb.exe'
$flutter = 'C:\Programing\flutter\bin\flutter.bat'
$appDir = 'C:\Programing\University\PMD\Lab_10\storage_app'
$pkg = 'com.example.storage_app.storage_app'
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

# 6. Build + install + run the Lab 10 app via flutter run (background, detached)
$runlog = Join-Path $appDir '_flutter_run.log'
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $flutter
$psi.Arguments = "run -d emulator-5554"
$psi.WorkingDirectory = $appDir
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.UseShellExecute = $false
$rp = [System.Diagnostics.Process]::Start($psi)
$psi2 = [System.Diagnostics.Process]::StartInfo
$rp.StandardOutput.BaseStream.CopyTo([System.IO.File]::OpenWrite($runlog))
Log "FLUTTER-RUN-STARTED pid=$($rp.Id)"

# 7. Wait for the app to appear in the foreground (up to 480s)
$appUp = $false
for ($i = 0; $i -lt 96; $i++) {
  Start-Sleep -Seconds 5
  $cur = (& $adb -s emulator-5554 shell dumpsys window 2>&1 | Out-String)
  if ($cur -match 'mCurrentFocus.*' + [regex]::Escape($pkg)) { $appUp = $true; Log "APP-FOCUS at +$($i*5)s"; break }
  if ($rp.HasExited) { Log "FLUTTER-RUN-EXITED=$($rp.ExitCode) at +$($i*5)s"; break }
}
if (-not $appUp) { Log "APP-NOT-FOCUSED after 480s"; exit 1 }

# 8. Wait a bit for first frame, screenshot
Start-Sleep -Seconds 6
New-Item -ItemType Directory -Force -Path 'C:\Programing\University\PMD\Lab_10\shots' | Out-Null
$psi3 = New-Object System.Diagnostics.ProcessStartInfo
$psi3.FileName = $adb
$psi3.Arguments = '-s emulator-5554 exec-out screencap -p'
$psi3.RedirectStandardOutput = $true
$psi3.UseShellExecute = $false
$cp = [System.Diagnostics.Process]::Start($psi3)
$fs = [System.IO.File]::OpenWrite('C:\Programing\University\PMD\Lab_10\shots\l10_now.png')
$cp.StandardOutput.BaseStream.CopyTo($fs)
$fs.Close(); $cp.WaitForExit(10000)
Log "SHOT-SAVED"

# 9. Window visibility check
$w = (Get-Process emulator -ErrorAction SilentlyContinue | Select-Object -First 1).MainWindowTitle
Log "WINDOW-TITLE=[$w]"
Log "RUN-END"
Write-Output "DONE"
