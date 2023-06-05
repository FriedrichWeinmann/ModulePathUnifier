# ModulePathUnifier

Welcome to the small mini-project for a PowerShell module that helps with having one central module path for all PS Versions that requires zero interaction with the user to set up.
What does this module do?

+ If not running on Windows: Nothing. The problem this module solves is Windows specific.
+ Creates a folder named "PSModules" in the user's documents folder
+ Injects that folder into $env:PSModulePath as the highest priority
+ Updates the user profile (CurrentUserAllHosts) to also update the modulepath

Finally, it provides a command for the module to copy itself over to that path when needed: `Copy-MpuModule`

> This module will perform no actions if:

+ running under a SYSTEM account.
+ the module that is calling is has been installed to ProgramFiles

## How to use

Update your module manifest to include this module as a dependency:

```powershell
RequiredModules = @(
    'ModulePathUnifier'
)
```

Then during your own module's import, call `Copy-MpuModule`:

```powershell
# Just the module itself
Copy-MpuModule

# Also include all the dependencies
Copy-MpuModule -Recurse
```

That's it.
