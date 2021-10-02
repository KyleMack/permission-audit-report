# Create-PermissionReport.ps1
#
# By Kyle MacKenzie

param(
    [Parameter(Mandatory=$False,HelpMessage="Specifies whether or not to perform a test run (do not create file)")]
    [boolean]$TestRun,

    [Parameter(Mandatory=$False,HelpMessage="The root directory to start reading permissions")]
    [boolean]$Path,

    [Parameter(Mandatory=$False,HelpMessage="Whether or not to traverse subfolders in root directory")]
    [boolean]$TraverseSubFolders,

    [Parameter(Mandatory=$False,HelpMessage="Read Active Directory for additional permissions from groups")]
    [boolean]$ExpandADPermissions,

    [Parameter(Mandatory=$False,HelpMessage="Output file permissions. True by default")]
    [boolean]$CheckFiles,

    [Parameter(Mandatory=$False,HelpMessage="Output folder permissions. True by default")]
    [boolean]$CheckFolders
)


*************************************************************************************
#                         DEFINE CLASS CONSTRUCTORS
*************************************************************************************

#Creates a new custom defined 'User' object
function NewUser(){

    $props = @{
        firstName = ''
        lastName = ''
        fullName = ''
    };

    $user = New-Object psobject -Property $props;

    return $user;
}


*************************************************************************************
#                         DEFINE HELPER METHODS
*************************************************************************************
