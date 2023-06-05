function Copy-MpuModule {
	<#
	.SYNOPSIS
		Copies the calling command into the shared modulepath.
	
	.DESCRIPTION
		Copies the calling command into the shared modulepath.
		Call this during your module's import to make it available to all PowerShell versions.
	
	.EXAMPLE
		PS C:\> Copy-MpuModule
		
		Copies the calling command into the shared modulepath.
	#>
	[CmdletBinding()]
	param (
		
	)
	process {
		if (-not (Test-IsEnabled)) { return }

		$caller = (Get-PSCallStack)[1]

		$module = $caller.InvocationInfo.MyCommand.Module
		if (-not $module -and $caller.InvocationInfo.MyCommand.Name -like '*.psm1') {
			$module = Get-Module -Name ($caller.InvocationInfo.MyCommand.Path -replace 'psm1$', 'psd1') -ListAvailable -ErrorAction Ignore
			# Case: Module not found
			if (-not $module -or $module.Guid -eq [guid]::Empty) { return }
		}
		$moduleBase = $module.ModuleBase
		if (-not $moduleBase) { return }
		if ($moduleBase -like "$env:ProgramFiles*") { return }

		$targetRoot = Join-Path -Path $script:modulePath -ChildPath "$($module.Name)\$($module.Version)"
		if (Test-Path -Path "$targetRoot\$($module.Name).psd1") { return }
		if (-not (Test-Path -Path $targetRoot)) {
			$null = New-Item -Path $targetRoot -ItemType Directory -Force
		}

		Copy-Item -Path "$moduleBase\*" -Destination $targetRoot -Recurse
	}
}