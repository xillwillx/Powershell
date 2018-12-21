#Decodes Base64 encoded AdministratorPassword in unattend.xml
# ./unattend.ps1 <PathToXML>
# illwill - 2k18

param([string]$a)
if ($a) { 
	if (!(Test-Path $a)) {
	  Write-Warning "$a not found!"
	}
	else {
	  Write-Host "[Decoded AdministratorPassword in $a]"
	  [ xml ]$fileContents = Get-Content -Path $a
	  $encpwd = $fileContents.unattend.settings.component.UserAccounts.AdministratorPassword.Value
	  $decpwd= ([system.text.encoding]::Unicode.GetString([system.convert]::Frombase64string($encpwd)))
	  Write-Host $decpwd.Substring(0,($decpwd.length-21)) 
	}
}
else { 
	Write-Host "Please provide path to unattend.xml`nUsage: .\unattend.ps1 <PathToXML>" 
}
