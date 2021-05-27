# escape=`

# This is a custom SDK image based on servercore that serves two purposes:
#   * Allows us to build a mixed solution (framework and netcore)
#   * Allows us to run `dotnet watch` for rendering host development
#     (see https://github.com/dotnet/dotnet-docker/issues/1984)

ARG BUILD_IMAGE

FROM ${BUILD_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
