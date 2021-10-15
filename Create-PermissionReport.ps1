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

#TODO: ADD PARAMETER FOR LIST OF FILTERABLE PERMISSION LEAF NAMES


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
        Identity = ''
        Inherited = $null
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
        subfolders = @()
        subfiles = @()
    };

    $directory = New-Object psobject -Property $props; return $directory;

}

#*************************************************************************************
#                         DEFINE HELPER METHODS
#*************************************************************************************

function logR($msg){ Write-Host $msg -ForegroundColor Red }
function logG($msg){ Write-Host $msg -ForegroundColor Green }
function logY($msg){ Write-Host $msg -ForegroundColor Yellow }

#Create permission objects for each 
function GetPermissions($path){

    $permissions = @();
    $permissions += ((Get-ACL $path).Access | %{
            $ace = NewPermission;
            $ace.Identity = $_.IdentityReference;
            $ace.Inherited = $_.IsInherited; 
            $ace;
    } )

}



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
$_RootDir.path = (Resolve-Path -Path $path).Path;
$_RootDir.name = Split-Path $_RootDir.path -Leaf;

#Set processing flags
$folderFlag = $CheckFolders;
$fileFlag = $CheckFiles;
$recursiveFlag = $TraverseSubFolders;



#*************************************************************************************
#                         TEST CODE
#*************************************************************************************

#Check root directory
logY("The root directory is ["+$_RootDir.name+"]["+$_RootDir.path+"]")



#*************************************************************************************
#                         BEGIN PROCESSING
#*************************************************************************************

#Get all children from the root directory and add to Root.subfolders & Root.subfiles
#Only pull if enabled
if($folderFlag){
    $_RootDir.subfolders += (Get-ChildItem -Path $_RootDir.path -Directory | %{ 
        $dir = NewDirectory;
        $dir.name = $_.Name;
        $dir.path = (Resolve-path -Path ($_RootDir.path + "\\" + $_.Name)).Path;
        $dir;
     } )
}
if($fileFlag){
    $_RootDir.subfiles += Get-ChildItem -Path $_RootDir.path -File | %{
        $file = $_.Name;
        $file;
    }
}

#Starting with the root, process through each subfolder and store the permissions
$_RootDir.permissions += ((Get-ACL $_RootDir.Path).Access | %{ 
        
        $ace = NewPermission;
        $ace.Identity = $_.IdentityReference;
        $ace.Inherited = $_.IsInherited; 
        $ace;
    } )

#Process permissions for each subfolder
$totalSubfolders = $_RootDir.subfolders.length;
for ($i = 0; $i -lt $totalSubfolders; $i++){
    #Assign folder by reference
    $folder = [ref]$_RootDir.subfolders[$i];


}


#*************************************************************************************
#                         TEST CODE
#*************************************************************************************

#Display found child items

$_RootDir.subfolders | ForEach-Object { logY("Subfolder of root ["+$_RootDir.name+"] found: ["+$_.name+"]"); }
$_RootDir.subfiles | ForEach-Object { logY("Subfile of root ["+$_RootDir.name+"] found: ["+$_+"]"); }
$_RootDir.permissions | ForEach-Object { logY("Permission on root found: ["+$_.Identity+"]"); }