# Use the official .NET 9 runtime as the base image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Use the .NET 9 SDK for building
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy project files
COPY ["MoRS.ManagementSystem.API/MoRS.ManagementSystem.API.csproj", "MoRS.ManagementSystem.API/"]
COPY ["MoRS.ManagementSystem.Application/MoRS.ManagementSystem.Application.csproj", "MoRS.ManagementSystem.Application/"]
COPY ["MoRS.ManagementSystem.Domain/MoRS.ManagementSystem.Domain.csproj", "MoRS.ManagementSystem.Domain/"]
COPY ["MoRS.ManagementSystem.Infrastructure/MoRS.ManagementSystem.Infrastructure.csproj", "MoRS.ManagementSystem.Infrastructure/"]

# Restore dependencies
RUN dotnet restore "MoRS.ManagementSystem.API/MoRS.ManagementSystem.API.csproj"

# Copy everything else and build
COPY . .
WORKDIR "/src/MoRS.ManagementSystem.API"
RUN dotnet build "MoRS.ManagementSystem.API.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "MoRS.ManagementSystem.API.csproj" -c Release -o /app/publish

# Final stage/image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Copy Images folder for profile pictures
COPY MoRS.ManagementSystem.API/Images/ ./Images/

# Create directory for SSL certificates
RUN mkdir -p /https

# Set environment variables
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:80

ENTRYPOINT ["dotnet", "MoRS.ManagementSystem.API.dll"]
