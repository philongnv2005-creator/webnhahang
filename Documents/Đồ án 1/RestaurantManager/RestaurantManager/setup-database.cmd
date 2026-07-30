@echo off
dotnet tool install --global dotnet-ef --version 8.0.29
if errorlevel 1 dotnet tool update --global dotnet-ef --version 8.0.29
dotnet restore
dotnet ef migrations add InitialCreate
dotnet ef database update
pause
