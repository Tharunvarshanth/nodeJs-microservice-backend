CREATE USER 'keycloakuser'@'%' IDENTIFIED BY 'keycloak';
create database keycloak;
GRANT ALL PRIVILEGES ON *.* TO 'keycloakuser'@'%';