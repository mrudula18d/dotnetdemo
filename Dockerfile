FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

RUN apt-get update
RUN apt-get -y install curl gnupg 
RUN curl -sL https://deb.nodesource.com/setup_16.x  | bash -
RUN apt-get -y install nodejs

COPY ["dotnet6.csproj", "/src"]
RUN dotnet restore "dotnet6.csproj"
COPY . .

RUN dotnet build "dotnet6.csproj" -c Release -o /app/build

FROM base AS publish
RUN dotnet publish "dotnet6.csproj" -c Release -o /app/publish

FROM base AS final 
ENV ASPNETCORE_URLS http://*:5000

WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 5000
ENTRYPOINT ["dotnet", "dotnet6.dll"]