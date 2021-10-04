# Create-PermissionReport.ps1
#
# By Kyle MacKenzie

param(
    [Parameter(Mandatory=$False,HelpMessage="Specifies whether or not to perform a test run (do not create file)")]
    [boolean]$TestRun = $False,

    [Parameter(Mandatory=$False,HelpMessage="The root directory to start reading permissions")]
    [string]$Path = '.',

    [Parameter(Mandatory=$False,HelpMessage="Whether or not to traverse subfolders in root directory (Default:False)")]
    [boolean]$TraverseSubFolders = $False,

    [Parameter(Mandatory=$False,HelpMessage="Read Active Directory for additional permissions from groups (Default:False)")]
    [boolean]$ExpandADPermissions = $True,

    [Parameter(Mandatory=$False,HelpMessage="Output file permissions (Default:True)")]
    [boolean]$CheckFiles = $True,

    [Parameter(Mandatory=$False,HelpMessage="Output folder permissions (Default:True)")]
    [boolean]$CheckFolders = $True
)


#*************************************************************************************
#                         DEFINE CLASS CONSTRUCTORS
#*************************************************************************************

#Creates a new custom defined 'User' object
function NewUser(){

    $props = @{
        firstName = ''
        lastName = ''
        fullName = ''
    };

    $user = New-Object psobject -Property $props; return $user;
}

#Creates a new custom defined 'Permission' object
function NewPermission(){

    $props = @{
        User = $null
        source = ''
        read = $null
        write = $null
        execute = $null

    };

    $permission = New-Object psobject -Property $props; return $permission;

}

#Creates a new custom defined 'Directory' object
function NewDirectory(){

    $props = @{
        name = ''
        path = ''
        permissions = @()
        reference = $null
    };

    $directory = New-Object psobject -Property $props; return $directory;

}

#*************************************************************************************
#                         DEFINE HELPER METHODS
#*************************************************************************************

function logR($msg){ Write-Host $msg -ForegroundColor Red }
function logG($msg){ Write-Host $msg -ForegroundColor Green }
function logY($msg){ Write-Host $msg -ForegroundColor Yellow }



#*************************************************************************************
#                         INITIAL VALIDATION
#*************************************************************************************

#Check that there is a valid directory
#If the path is default, use the current directory
if( $path -NE '.' ){

    if( ![System.IO.Directory]::Exists($path) ){
        throw "Cannot find specified path"
    }

}

#*************************************************************************************
#                         VARIABLE DECLARATION
#*************************************************************************************

#Create root directory object
$_RootDir = NewDirectory;
$_RootDir.path = Resolve-Path -Path $path;
$_RootDir.name = Split-Path $_RootDir.path -Leaf;





#*************************************************************************************
#                         TEST CODE
#*************************************************************************************

#Check root directory
logY("The root directory is ["+$_RootDir.path+"]")

#Read all entries from the root directory



#*************************************************************************************
#                         BEGIN PROCESSING
#*************************************************************************************

#TODO: Create Directory Object
