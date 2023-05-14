# Create a new Named Location
# To use, edit the custom parameters at the bottom with your values
# Countries must follow  ISO 3166-1 alpha-2 country code standard

$scopes = "Policy.ReadWrite.ConditionalAccess","Policy.Read.All"
Connect-MgGraph -scopes $scopes

function CreateNamedLocationPolicy {
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$Countries,

        [Parameter(Mandatory=$true)]
        [string]$PolicyName
    )

    # Check if the named location policy already exists
    $existingPolicy = Get-MgIdentityConditionalAccessNamedLocation | Where-Object { $_.DisplayName -eq $PolicyName }

    if ($existingPolicy -eq $null) {
        # If the named location policy doesn't exist, create it
        try {
            $params = @{
                "@odata.type" = "#microsoft.graph.countryNamedLocation"
                displayName = $PolicyName
                countriesAndRegions = $Countries
                includeUnknownCountriesAndRegions = $false
            }

            New-MgIdentityConditionalAccessNamedLocation -BodyParameter $params
            Write-Output "Named location policy '$PolicyName' created successfully."
        }
        catch {
            $errorMessage = $_.Exception.Message
            Write-Error "Failed to create the named location policy '$PolicyName'. Error: $errorMessage"
        }
    }
    else {
        Write-Output "Named location policy '$PolicyName' already exists."
    }
}

# Call the function with custom parameters
# Replace values between quotes with custom values
$Countries = ""
$PolicyName = ""

CreateNamedLocationPolicy -Countries $Countries -PolicyName $PolicyName
