CREATE USER 'keycloakuser' IDENTIFIED BY 'keycloak';
create database keycloak;
GRANT ALL PRIVILEGES ON keycloak TO 'keycloakuser'@'%' WITH GRANT OPTION;
/*GRANT ALL PRIVILEGES ON  keycloak TO 'keycloakuser';*/