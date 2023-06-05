function Test-IsWindows {
	<#
	.SYNOPSIS
		Returns, whether the current OS is windows.
	
	.DESCRIPTION
		Returns, whether the current OS is windows.
	
	.EXAMPLE
		PS C:\> Test-IsWindows
		
		Returns, whether the current OS is windows.
	#>
	[CmdletBinding()]
	param ()

	process {
		$PSVersionTable.PSVersion.Major -lt 6 -or $IsWindows
	}
}