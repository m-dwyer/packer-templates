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

# Remove apps
Write-Host "Removing apps..."
$apps = @(
    "Microsoft.3DBuilder"
    "Microsoft.Appconnector"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingWeather"
    "Microsoft.BioEnrollment"
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
    "Microsoft.WindowsFeedback"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.WindowsStore"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameCallableUI"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
)

foreach ($app in $apps) {
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage
    Get-AppXProvisionedPackage -Online |
        Where DisplayName -eq $app |
        Remove-AppxProvisionedPackage -Online
}

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
