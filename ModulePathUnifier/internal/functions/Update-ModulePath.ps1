function Update-ModulePath {
	<#
	.SYNOPSIS
		Creates a central module path and updates the profile to load it.
	
	.DESCRIPTION
		Creates a central module path and updates the profile to load it.
	
	.EXAMPLE
		PS C:\> Update-ModulePath
		
		Creates a central module path and updates the profile to load it.
	#>
	[CmdletBinding()]
	param ()
	
	process {
		if (-not (Test-IsEnabled)) { return }

		if (-not (Test-Path $script:modulePath)) {
			$null = New-Item -Path $script:modulePath -ItemType Directory -Force
		}
		$insertLine = 'if ($env:PSModulePath -notlike ''*{0}*'') {{ $env:PSModulePath = ''{0}'', $env:PSModulePath -join '';'' }}' -f $script:modulePath
		if ($env:PSModulePath -notlike "*$script:modulePath*") { $env:PSModulePath = $script:modulePath, $env:PSModulePath -join ';' }

		$path = $profile.CurrentUserAllHosts
		$profileFolder = Split-Path $Path

		if (-not (Test-Path $profileFolder)) {
			$null = New-Item -Path $profileFolder -ItemType Directory -Force
		}

		if (-not (Test-Path $path)) {
			$insertLine | Set-Content -Path $path
			return
		}
		if ((Get-Content -Path $Path) -contains $insertLine) {
			return
		}

		$profileContent = @($insertLine) + @(Get-Content -Path $path)
		$profileContent | Set-Content -Path $path
	}
}