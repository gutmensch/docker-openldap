ARG OPENLDAP_VERSION=2.6.1

FROM registry.n-os.org:5000/root-ca:20220205 AS certs

FROM bitnami/openldap:$OPENLDAP_VERSION

ARG SLAPD_UID=2000

COPY --from=certs /CA/certs/ldap/ /etc/ssl/certs/ldap/

ENV LDAP_ENABLE_TLS=yes \
    LDAP_TLS_CERT_FILE=/etc/ssl/certs/ldap/server.crt \
    LDAP_TLS_KEY_FILE=/etc/ssl/certs/ldap/server.key \
    LDAP_TLS_CA_FILE=/etc/ssl/certs/ldap/ca.crt \
    LDAP_TLS_DH_PARAMS_FILE=/etc/ssl/certs/ldap/dhparams.pem

USER root
RUN chown -R $SLAPD_UID /bitnami/openldap \
  && chown -R $SLAPD_UID /etc/ssl/certs/ldap \
  && chmod 400 /etc/ssl/certs/ldap/server.key \
  && ln -s /etc/ssl/certs/ldap/ca.crt /usr/local/share/ca-certificates/docker_root_ca.crt \
  && update-ca-certificates \
  && openssl verify -verbose /etc/ssl/certs/ldap/server.crt


VOLUME ["/bitnami/openldap"]

USER $SLAPD_UID
