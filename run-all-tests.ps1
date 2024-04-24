$directories = Get-ChildItem -Directory | Where-Object { $_.Name -like "tf-az*" }

foreach ($dir in $directories) {
    Push-Location $dir.FullName
    Write-Host "Entering directory: $dir.FullName"
    terraform init
    if ($?) {
        terraform test
    } else {
        Write-Host "Terraform init failed in $dir.FullName"
        Pop-Location
    }

    Pop-Location
}

Write-Host "Completed processing all directories."
