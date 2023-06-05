
if (Test-IsWindows) {
	$script:modulePath = ([System.Environment]::GetFolderPath('MyDocuments')),'PSModules' -join '\'
	Update-ModulePath
}