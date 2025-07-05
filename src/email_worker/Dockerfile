# Use the official .NET 9 runtime as the base image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app

# Use the .NET 9 SDK for building
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy project file
COPY ["MoRS.ManagementSystem.EmailWorker/MoRS.ManagementSystem.EmailWorker.csproj", "MoRS.ManagementSystem.EmailWorker/"]

# Restore dependencies
RUN dotnet restore "MoRS.ManagementSystem.EmailWorker/MoRS.ManagementSystem.EmailWorker.csproj"

# Copy everything else and build
COPY . .
WORKDIR "/src/MoRS.ManagementSystem.EmailWorker"
RUN dotnet build "MoRS.ManagementSystem.EmailWorker.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "MoRS.ManagementSystem.EmailWorker.csproj" -c Release -o /app/publish

# Final stage/image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Set environment variables
ENV DOTNET_ENVIRONMENT=Production

ENTRYPOINT ["dotnet", "MoRS.ManagementSystem.EmailWorker.dll"]
