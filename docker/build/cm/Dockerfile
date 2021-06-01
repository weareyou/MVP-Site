# escape=`

ARG BASE_IMAGE
ARG SXA_IMAGE
ARG SPE_IMAGE
ARG TOOLING_IMAGE
ARG SOLUTION_IMAGE

ARG DEVEX_RESOURCES_IMAGE
ARG JSS_RESOURCES_IMAGE

FROM ${SOLUTION_IMAGE} as solution
FROM ${TOOLING_IMAGE} as tooling
FROM ${DEVEX_RESOURCES_IMAGE} AS devex_resources
FROM ${JSS_RESOURCES_IMAGE} AS jss_resources
FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Copy development tools and entrypoint
COPY --from=tooling \tools\ \tools\

WORKDIR C:\inetpub\wwwroot

# Add SPE module
COPY --from=spe \module\cm\content .\

# Add SXA module
COPY --from=sxa \module\cm\content .\
COPY --from=sxa \module\tools \module\tools
RUN C:\module\tools\Initialize-Content.ps1 -TargetPath .\; `
    Remove-Item -Path C:\module -Recurse -Force;

# Copy the Sitecore Management Services Module
COPY --from=devex_resources C:\module\cm\content C:\inetpub\wwwroot

# Copy and init the JSS / Headless Services Module
COPY --from=jss_resources C:\module\cm\content C:\inetpub\wwwroot
COPY --from=jss_resources C:\module\tools C:\module\tools
RUN C:\module\tools\Initialize-Content.ps1 -TargetPath C:\inetpub\wwwroot; `
    Remove-Item -Path C:\module -Recurse -Force;

# Copy solution website files
COPY --from=solution \artifacts\website\ .\

# Copy solution transforms
COPY --from=solution \artifacts\transforms\ \transforms\solution\

# Copy role transforms
COPY .\transforms\ \transforms\role\

# Perform solution transforms
RUN C:\tools\scripts\Invoke-XdtTransform.ps1 -Path .\ -XdtPath C:\transforms\solution\DockerExamples.Website

# Perform role transforms
RUN C:\tools\scripts\Invoke-XdtTransform.ps1 -Path .\ -XdtPath C:\transforms\role