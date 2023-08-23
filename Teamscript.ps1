Install-Module -Name MicrosoftTeams

# Read credentials from the console
$credentials = Get-Credential

# Connect to Microsoft Teams
$tenantInformation = Connect-MicrosoftTeams -Credential $credentials
$tenantId = $tenantInformation.TenantId

# Fetch all teams from the tenant
$teams = Get-Team
$results = [System.Collections.ArrayList]::new()

# Iterate through the teams
foreach ($team in $teams) {
    $allTeamMembers = [System.Collections.ArrayList]::new()

    # Fetch the team members
    $members = Get-TeamUser -GroupId $team.GroupId

    # Iterate through the members
    foreach ($member in $members) {
        $allTeamMembers.Add([PSCustomObject]@{
            TeamName = $team.DisplayName
            TeamId = $team.GroupId
            OwnerName = $member.User
            OwnerFullName = $member.Name
            OwnerId = $member.UserId
            Role = $member.Role
            TenantId = $tenantId
        }) > $null
    }

    # Add the team and its members to the results
    $results.AddRange($allTeamMembers) > $null
}

if ($results.Count -eq 0) {
    return
}
