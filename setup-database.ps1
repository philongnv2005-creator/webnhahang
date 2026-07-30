$ErrorActionPreference = "Stop"
dotnet tool install --global dotnet-ef --version 8.0.29 2>$null
if ($LASTEXITCODE -ne 0) { dotnet tool update --global dotnet-ef --version 8.0.29 }
dotnet restore
dotnet ef migrations add InitialCreate
dotnet ef database update
Write-Host "Database created successfully." -ForegroundColor Green
