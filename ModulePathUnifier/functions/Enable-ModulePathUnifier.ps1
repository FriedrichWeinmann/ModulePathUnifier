function Enable-ModulePathUnifier {
	<#
	.SYNOPSIS
		Re-enables this module after having previously disabled it.
	
	.DESCRIPTION
		Re-enables this module after having previously disabled it.
		Use Disable-ModulePathUnifier to disable this module.
	
	.EXAMPLE
		PS C:\> Enable-ModulePathUnifier
		
		Re-enables this module after having previously disabled it.
	#>
	[CmdletBinding()]
	param (
		
	)
	process {
		if (-not $env:LOCALAPPDATA) { return }

		$disablePath = Join-Path $env:LOCALAPPDATA "ModulePathUnifier_Disabled.txt"
		Remove-Item -Path $disablePath -ErrorAction Ignore

		$script:modulePath = ([System.Environment]::GetFolderPath('MyDocuments')),'PSModules' -join '\'
	}
}