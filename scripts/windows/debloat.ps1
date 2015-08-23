# Stop and disable services
Write-Host "Stopping and disabling services.."
$services = @(
    "wuauserv"
    "HomeGroupListener"
    "HomeGroupProvider"
    "MapsBroker"
    "SharedAccess"
    "WbioSrvc"
    "XblAuthManager"
    "XblGameSave"
    "XboxNetApiSvc"
    "dmwappushservice"
    "lfsvc"
    "DiagTrack"
    "Spooler"
)

foreach ($service in $services) {
    Stop-Service -Name $service -Force
    Set-Service -Name $service -StartupType Disabled
}

# Remove OneDrive
Write-Host "Removing OneDrive..."
Stop-Process -Name "OneDriveSetup" -Force
Stop-Process -Name "OneDrive" -Force
Move-Item "C:\Windows\SysWOW64\OneDriveSetup.exe" "C:\Windows\SysWow64\OneDriveSetup-old.exe"
&"C:\Windows\SysWOW64\OneDriveSetup-old.exe" /Uninstall

Remove-Item -Recurse -Force -Confirm:$false "Registry::HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
Remove-Item -Recurse -Force -Confirm:$false "Registry:HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"

Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force
Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Recurse -Force

# Disable features
Write-Host "Disabling features..."
$features = @(
    "FaxServicesClientPackage"
    "Internet-Explorer-Optional-amd64"
    "MediaPlayback"
    "Printing-PrintToPDFServices-Features"
    "Printing-XPSServices-Features"
    "Printing-Foundation-Features"
    "Printing-Foundation-InternetPrinting-Client"
    "WindowsMediaPlayer"
    "WorkFolders-Client"
)

Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName $features

$packageNames = @(
    "BioEnrollment"
    "Biometrics"
    "ContactSupport"
    "DiagTrack"
    "Feedback"
    "Flash"
    "Hyper-V"
    "Gaming"
    "OneDrive"
    "Windows-Defender"
    "Xbox"
)

$appXPackageNames = @(
    "Microsoft.3DBuilder"
    "Microsoft.Appconnector"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingWeather"
    "Microsoft.Getstarted"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.Office.OneNote"
    "Microsoft.People"
    "Microsoft.SkypeApp"
    "Microsoft.Windows.Photos"
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsCalculator"
    "Microsoft.WindowsCamera"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.WindowsStore"
    "Microsoft.XboxApp"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
)

$username = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

$hiveStr = "HKLM"
$keyStr = "SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages"

$key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($keyStr,[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::ChangePermissions)
$acl = $key.GetAccessControl()
$rule = New-Object System.Security.AccessControl.RegistryAccessRule("$username", "FullControl", "ContainerInherit", "None", "Allow")
$acl.SetAccessRuleProtection($false, $false)
$acl.AddAccessRule($rule)
$key.SetAccessControl($acl)

# Remove all the things
foreach ($packageName in $packageNames)
{
    $packageKeys = (Get-ChildItem "$hiveStr`:\$keyStr" |
                Where Name -Like "*$packageName*")

    foreach ($packageKey in $packageKeys)
    {
        Set-ItemProperty -Path $packageKey.PSPath -Name Visibility -Value 1 -ErrorAction SilentlyContinue | Out-Null
        New-ItemProperty -Path $packageKey.PSPath -Name DefVis -PropertyType Dword -Value 2 -ErrorAction SilentlyContinue | Out-Null
        Remove-Item -Path "$($packageKey.PSPath)\Owners" | Out-Null

        Write-Host "Attempting to remove $($packageKey.PSChildName)..."
        &dism.exe /Online /Remove-Package /PackageName:$($packageKey.PSChildName) /NoRestart /Quiet
    }
}

foreach ($appXPackageName in $appXPackageNames) {
    $appXPackage = Get-AppXProvisionedPackage -Online | Where DisplayName -like "*$appXPackageName*"

    Write-Host "Attempting to remove $($appXPackage.DisplayName)..."
    $appXPackage | Remove-AppxProvisionedPackage -Online
    Get-AppxPackage | Where Name -Like "*$appXPackageName*" | Remove-AppxPackage
}

$LASTEXITCODE = 0
