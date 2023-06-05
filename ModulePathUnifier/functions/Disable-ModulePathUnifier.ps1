function Disable-ModulePathUnifier {
	<#
	.SYNOPSIS
		Disables the ModulePathUnifier module.
	
	.DESCRIPTION
		Disables the ModulePathUnifier module.
		Sets a flag in the user profile (under LocalAppData) that tells this module to stop doing its work.
		Use Enable-ModulePathUnifier to reenable it.
	
	.EXAMPLE
		PS C:\> Disable-ModulePathUnifier
		
		Disables the ModulePathUnifier module.
	#>
	[CmdletBinding()]
	param (
		
	)
	process {
		if (-not $env:LOCALAPPDATA) { return }

		$disablePath = Join-Path $env:LOCALAPPDATA "ModulePathUnifier_Disabled.txt"
		'Module has been disabled and will not copy modules or maintain a central modulepath anymore. Does not affect your $profile content' | Set-Content $disablePath
	}
}