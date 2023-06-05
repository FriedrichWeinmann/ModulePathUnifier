function Copy-MpuModule {
	<#
	.SYNOPSIS
		Copies the calling command into the shared modulepath.
	
	.DESCRIPTION
		Copies the calling command into the shared modulepath.
		Call this during your module's import to make it available to all PowerShell versions.

	.PARAMETER Module
		Module to copy.
		Autodetects the module from the caller if not specified.

	.PARAMETER Recurse
		Also copy all modules your module depends (recursively)
	
	.EXAMPLE
		PS C:\> Copy-MpuModule
		
		Copies the calling command into the shared modulepath.
	#>
	[CmdletBinding()]
	param (
		$Module,

		[switch]
		$Recurse
	)
	process {
		if (-not (Test-IsEnabled)) { return }

		$caller = (Get-PSCallStack)[1]

		$moduleObject = $Module
		if (-not $moduleObject) {
			$moduleObject = $caller.InvocationInfo.MyCommand.Module
			if (-not $moduleObject -and $caller.InvocationInfo.MyCommand.Name -like '*.psm1') {
				$moduleObject = Get-Module -Name ($caller.InvocationInfo.MyCommand.Path -replace 'psm1$', 'psd1') -ListAvailable -ErrorAction Ignore
				# Case: Module not found
				if (-not $moduleObject -or $moduleObject.Guid -eq [guid]::Empty) { return }
			}
		}
		$moduleBase = $moduleObject.ModuleBase
		if (-not $moduleBase) { return }
		if ($moduleBase -like "$env:ProgramFiles*") { return }

		$targetRoot = Join-Path -Path $script:modulePath -ChildPath "$($moduleObject.Name)\$($moduleObject.Version)"
		if (Test-Path -Path "$targetRoot\$($module.Name).psd1") { return }
		if (-not (Test-Path -Path $targetRoot)) {
			$null = New-Item -Path $targetRoot -ItemType Directory -Force
		}

		Copy-Item -Path "$moduleBase\*" -Destination $targetRoot -Recurse

		if ($Recurse) {
			$allModulesLoaded = Get-Module
			foreach ($dependency in $allModulesLoaded | Where-Object Name -In $moduleObject.RequiredModules.Name) {
				Copy-MpuModule -Module $dependency -Recurse
			}
		}
	}
}