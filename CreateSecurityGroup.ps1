# Create a Security Group
# Use by typing Create-Group -GroupName "MyGroup"
$scopes = "User.Read.All","Group.ReadWrite.All"
Connect-MgGraph -scopes $scopes


function CreateSecurityGroup {
    param (
        [Parameter(Mandatory = $true)]
        [string]$GroupName
    )

    # Check if the group exists
    try {
        $travelGroup = Get-MgGroup -Filter "DisplayName eq '$GroupName'"
    }
    catch {
        $travelGroup = $null
    }

    if ($travelGroup -eq $null) {
        # If the group doesn't exist, create it
        try {
            New-MgGroup -DisplayName $GroupName `
			-MailEnabled:$False  `
			-MailNickName "NotSet" `
			-SecurityEnabled
            Write-Output "Group '$GroupName' created successfully."
        }
        catch {
			Write-Error $_.Exception
            Write-Error "Failed to create the group '$GroupName'."
        }
    }
}

CreateSecurityGroup