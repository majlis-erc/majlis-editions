FROM evolvedbinary/elemental:${elemental.version}

# Copy majlis-editions dependencies XAR files to Elemental's autodeploy folder
COPY tei-publisher-lib-${tei-publisher-lib.xar.version}.xar   /elemental/autodeploy/
COPY roaster-${roaster.xar.version}.xar                        /elemental/autodeploy/


# Copy majlis-editions XAR to Elemental's autodeploy folder
COPY ${package-final-name}.xar /elemental/autodeploy/

# Build-time metadata as defined at http://label-schema.org
# and used by autobuilder @hooks/build
LABEL org.label-schema.build-date=${maven.build.timestamp} \
      org.label-schema.description="${project.description}" \
      org.label-schema.name="${project.name}" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url="${project.url}" \
      org.label-schema.vcs-ref=${build-commit-abbrev} \
      org.label-schema.vcs-url="${project.scm.url}" \
      org.label-schema.vendor="${project.organization.name}" \
      org.opencontainers.image.source="${project.scm.url}"

EXPOSE 8080 8443
