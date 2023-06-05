function Test-IsEnabled {
	<#
	.SYNOPSIS
		Returns, whether the module should act.
	
	.DESCRIPTION
		Returns, whether the module should act.

		Should NOT act if:
		- Is Disabled
		- Is not on Windows
		- Is a SYSTEM account
	
	.EXAMPLE
		PS C:\> Test-IsEnabled
		
		Returns, whether the module should act.
	#>
	[CmdletBinding()]
	param ()

	process {
		$isWin = $PSVersionTable.PSVersion.Major -lt 6 -or $IsWindows
		if (-not $isWin) { return $false }

		if ($env:LOCALAPPDATA) {
			$disablePath = Join-Path $env:LOCALAPPDATA "ModulePathUnifier_Disabled.txt"
			if (Test-Path $disablePath) { return $false }
		}

		[System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value -notmatch '^S-1-5-'
	}
}