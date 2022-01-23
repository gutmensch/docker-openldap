ARG OPENLDAP_VERSION=2.6.1

FROM bitnami/openldap:$OPENLDAP_VERSION

ARG SLAPD_UID=2000

USER root
RUN chown -R $SLAPD_UID /bitnami/openldap

VOLUME ["/bitnami/openldap"]

USER $SLAPD_UID
