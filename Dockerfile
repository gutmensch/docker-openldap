ARG IMAGE_VERSION=2.6.1

FROM registry.n-os.org:5000/root-ca:20220205 AS certs

FROM bitnami/openldap:$IMAGE_VERSION

ARG IMAGE_UID=2000

COPY --from=certs /CA/certs/ldap/ /etc/ssl/certs/ldap/

ENV LDAP_ENABLE_TLS=yes \
    LDAP_TLS_CERT_FILE=/etc/ssl/certs/server.crt \
    LDAP_TLS_KEY_FILE=/etc/ssl/certs/server.key \
    LDAP_TLS_CA_FILE=/etc/ssl/certs/ca.crt \
    LDAP_TLS_DH_PARAMS_FILE=/etc/ssl/certs/dhparams.pem

USER root
RUN chown -R $IMAGE_UID /bitnami/openldap \
  && /etc/ssl/certs/ldap/setup.sh $IMAGE_UID

VOLUME ["/bitnami/openldap"]

USER $IMAGE_UID
