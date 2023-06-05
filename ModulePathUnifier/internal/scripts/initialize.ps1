
if (Test-IsEnabled) {
	$script:modulePath = ([System.Environment]::GetFolderPath('MyDocuments')),'PSModules' -join '\'
	Update-ModulePath
}