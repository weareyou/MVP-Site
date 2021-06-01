# escape=`

ARG BASE_IMAGE
ARG SXA_IMAGE
ARG SPE_IMAGE
ARG JSS_RESOURCES_IMAGE

FROM ${SPE_IMAGE} as spe
FROM ${SXA_IMAGE} as sxa
FROM ${JSS_RESOURCES_IMAGE} AS jss_resources
FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Add SPE module
COPY --from=spe \module\db \spe_data
RUN C:\DeployDatabases.ps1 -ResourcesDirectory C:\spe_data; `
    Remove-Item -Path C:\spe_data -Recurse -Force;
    
# Add SXA module
COPY --from=sxa \module\db \sxa_data
RUN C:\DeployDatabases.ps1 -ResourcesDirectory C:\sxa_data; `
    Remove-Item -Path C:\sxa_data -Recurse -Force;    
    
    
    
# Copy and init the JSS / Headless Services Module
COPY --from=jss_resources C:\module\db C:\jss_data
RUN C:\DeployDatabases.ps1 -ResourcesDirectory C:\jss_data; `
    Remove-Item -Path C:\jss_data -Recurse -Force;