#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["DemoGrpc.Web/DemoGrpc.Web.csproj", "DemoGrpc.Web/"]
COPY ["DempGrpc.Services/DempGrpc.Services.csproj", "DempGrpc.Services/"]
COPY ["DemoGrpc.Repository/DemoGrpc.Repository.csproj", "DemoGrpc.Repository/"]
COPY ["DemoGrpc.Domain/DemoGrpc.Domain.csproj", "DemoGrpc.Domain/"]
RUN dotnet restore "DemoGrpc.Web/DemoGrpc.Web.csproj"
COPY . .
WORKDIR "/src/DemoGrpc.Web"
RUN dotnet build "DemoGrpc.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DemoGrpc.Web.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DemoGrpc.Web.dll"]